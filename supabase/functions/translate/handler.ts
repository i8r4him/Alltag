// translate — translates between German and the learner's language, with OpenAI,
// and explains the German for a learner.
//
// The OpenAI API key never leaves this function. Nothing the learner wrote is
// stored: the table `translations` keeps only who asked and when, for the limits.
//
// Request:  POST, Authorization: Bearer <Supabase access token>
//           { "text": "How do I say I'm running late?",
//             "language": "English",     (the learner's language; default English)
//             "level": "A2",             (optional)
//             "register": "everyday" }   (optional: "everyday" | "formal", for "How do I say …?";
//                                         without it the German is the translator's natural German)
// Response: 200 { "german": "…", "other": "…", "source_is_german": false,
//                 "note": "…",
//                 "words":    [{ "word": "…", "grammar": "…", "meaning": "…" }],
//                 "tones":    [{ "tone": "formal" | "neutral" | "casual", "german": "…" }],
//                 "examples": [{ "german": "…", "other": "…" }] }
// Errors:   400 bad_request · 401 unauthorized · 405 method_not_allowed
//           429 daily_limit | busy · 502 upstream · 503 not_configured | unavailable

import { claim, clean, cefr, envNumber, json, outputText, refused, serviceClient, signedInUser } from "../_shared/server.ts";

const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY");
const MODEL = Deno.env.get("TRANSLATE_MODEL") ?? "gpt-6-luna";
/** Translations per user per rolling 24 hours. Accounts in `realtime_developers` are exempt. */
const PER_USER_DAILY = envNumber("TRANSLATE_PER_USER_DAILY", 200);
/** Translations for everyone per rolling 24 hours — a ceiling on the OpenAI bill. */
const GLOBAL_DAILY = envNumber("TRANSLATE_GLOBAL_DAILY", 20000);
const MAX_TEXT = 600;

/** How the German should sound, when "How do I say …?" chooses. Ignored when the text is German. */
const REGISTERS: Record<string, (language: string) => string> = {
  everyday: (language) => `
How the German should sound: everyday spoken German (Umgangssprache), the way people in Germany
really say it to friends, colleagues, neighbours and in shops. Use du, the short spoken forms
(„hab“, „gibt's“, „'nen“, „ich geh“), particles like „mal“, „halt“, „eben“, „doch“ and common
everyday words. Not rude, not dialect, not dated or youth slang; something a learner can say
anywhere without sounding odd. If the text is plainly for an email, a letter or an office, still
answer casually, and say in note (in ${language}) that the formal version fits better there.`,
  formal: (language) => `
How the German should sound: polite, written standard German with Sie, as in an email or a letter
to an office, a landlord, a company, a doctor or a teacher. Complete sentences, no short spoken
forms, no slang. If the text is an email or a letter, give it ready to send: a greeting
(„Sehr geehrte Damen und Herren,“ or „Guten Tag,“), the message, and a closing („Mit freundlichen
Grüßen“), without a name. note: one short sentence in ${language} on when this formal German fits.`,
};

const instructions = (language: string, register: string) =>
  `You are Alltag, a German tutor. The learner's own language is ${language}.
You get a text. If it is German, translate it into ${language}. Otherwise it is what the learner
wants to say: translate it into natural, everyday German, the way people in Germany really say it,
not word for word.

german: the German text (the translation, or the original if it was German).
other: the same in ${language}.
source_is_german: whether the text you got was German.
note: one short sentence in ${language} about register or usage, or an empty string.
words: the 1 to 5 words or short phrases of the German that a learner most needs. For each:
  word (a noun with its article), grammar (very short, e.g. „noun · pl. Termine“, „verb · separable“),
  meaning (in ${language}). For a single word, give that word.
tones: only when the German is a whole sentence someone would say: the same sentence as "formal",
  "neutral" and "casual". Otherwise an empty list.
examples: 1 or 2 short German sentences using the same words in another everyday situation, each
  with its meaning in ${language}.
Keep every field short. Write for the learner's level: simple words for A1 and A2.${REGISTERS[register]?.(language) ?? ""}`;

const SCHEMA = {
  type: "object",
  properties: {
    german: { type: "string" },
    other: { type: "string" },
    source_is_german: { type: "boolean" },
    note: { type: "string" },
    words: {
      type: "array",
      items: {
        type: "object",
        properties: { word: { type: "string" }, grammar: { type: "string" }, meaning: { type: "string" } },
        required: ["word", "grammar", "meaning"],
        additionalProperties: false,
      },
    },
    tones: {
      type: "array",
      items: {
        type: "object",
        properties: { tone: { type: "string", enum: ["formal", "neutral", "casual"] }, german: { type: "string" } },
        required: ["tone", "german"],
        additionalProperties: false,
      },
    },
    examples: {
      type: "array",
      items: {
        type: "object",
        properties: { german: { type: "string" }, other: { type: "string" } },
        required: ["german", "other"],
        additionalProperties: false,
      },
    },
  },
  required: ["german", "other", "source_is_german", "note", "words", "tones", "examples"],
  additionalProperties: false,
};

export async function handle(req: Request): Promise<Response> {
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);
  if (!OPENAI_API_KEY) return json({ error: "not_configured" }, 503);

  const admin = serviceClient();
  const userId = await signedInUser(admin, req);
  if (!userId) return json({ error: "unauthorized" }, 401);

  let body: Record<string, unknown> = {};
  try {
    body = await req.json();
  } catch {
    return json({ error: "bad_request" }, 400);
  }
  const text = clean(body.text, MAX_TEXT);
  if (!text) return json({ error: "bad_request" }, 400);
  // Only letters and spaces, so the language name can't carry instructions.
  const language = clean(body.language, 40).replace(/[^\p{L} ]/gu, "") || "English";
  const level = cefr(body.level);
  // Only a known register changes the instructions; anything else is ignored.
  const register = Object.hasOwn(REGISTERS, String(body.register)) ? String(body.register) : "";
  const streaming = body.stream === "true";

  const claimed = await claim(admin, "translations", userId, { perUser: PER_USER_DAILY, global: GLOBAL_DAILY });
  if (claimed.status !== "ok") return refused(claimed.status);

  const input = [
    level ? `Learner's level (CEFR): ${level}` : "",
    `Text: „${text}“`,
  ].filter(Boolean).join("\n");

  const request = () =>
    fetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: MODEL,
        stream: streaming,
        instructions: instructions(language, register),
        input,
        // A translation needs little thinking; low effort makes it several seconds quicker.
        reasoning: { effort: "low" },
        // The model's thinking counts against this.
        max_output_tokens: 3000,
        store: false,
        text: { format: { type: "json_schema", name: "translation", schema: SCHEMA, strict: true } },
      }),
      // A stream is read for as long as it runs, so only a plain answer has a time limit.
      signal: streaming ? undefined : AbortSignal.timeout(45000),
    });
  // Only answered translations count: a failure gives the claim back.
  const failed = async () => {
    await claimed.release();
    return json({ error: "upstream" }, 502);
  };
  let upstream: Response;
  try {
    // OpenAI sometimes refuses with 401 for a while after a key's permissions change. Ask again.
    upstream = await request();
    for (let attempt = 1; attempt < 5 && upstream.status === 401; attempt++) {
      await upstream.body?.cancel();
      upstream = await request();
    }
  } catch (error) {
    console.error("OpenAI translation request failed", String(error));
    return failed();
  }
  if (!upstream.ok) {
    console.error("OpenAI translation failed", upstream.status, await upstream.text());
    return failed();
  }
  if (streaming && upstream.body) {
    // Forward OpenAI's typed events without buffering the completed answer.
    // Non-streaming callers keep the original JSON response below.
    return new Response(upstream.body, {
      headers: { "Content-Type": "text/event-stream", "Cache-Control": "no-cache" },
    });
  }
  const response = await upstream.json();
  let result: Record<string, unknown>;
  try {
    result = JSON.parse(outputText(response) ?? "");
  } catch {
    console.error("OpenAI answer was not the expected JSON", response.status, Object.keys(response));
    return failed();
  }

  return json(result);
}
