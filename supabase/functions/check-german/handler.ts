// check-german — judges one German sentence a learner said, with OpenAI.
//
// The app sends text only, never audio, and the OpenAI API key never leaves
// this function. Nothing the learner said is stored: the table `german_checks`
// keeps only who asked and when, for the daily limits.
//
// Request:  POST, Authorization: Bearer <Supabase access token>
//           { "sentence": "Am Wochenende ich gehe in den Park.",
//             "previous": "<what the other person said before>",   (optional)
//             "context": "<situation or topic>",                    (optional)
//             "level": "A2" }                                       (optional)
// Response: 200 { "kind": "good" | "fix" | "note", "title": "…", "note": "…",
//                 "english": "…", "correction": "…" }
// Errors:   400 bad_request · 401 unauthorized · 405 method_not_allowed
//           429 daily_limit | busy · 502 upstream · 503 not_configured | unavailable

import { claim, clean, cefr, envNumber, json, outputText, refused, serviceClient, signedInUser } from "../_shared/server.ts";

const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY");
const MODEL = Deno.env.get("CHECK_MODEL") ?? "gpt-6-luna";
/** Sentences per user per rolling 24 hours. Accounts in `realtime_developers` are exempt. */
const PER_USER_DAILY = envNumber("CHECK_PER_USER_DAILY", 300);
/** Sentences for everyone per rolling 24 hours — a ceiling on the OpenAI bill. */
const GLOBAL_DAILY = envNumber("CHECK_GLOBAL_DAILY", 20000);
const MAX_SENTENCE = 500;
const MAX_CONTEXT = 400;

const INSTRUCTIONS = `You are Alltag, a warm and precise German tutor.
A learner SAID the sentence below out loud; speech recognition wrote it down.
Judge only that sentence, as spoken German.

kind:
- "fix": a real mistake in grammar, word order, case, gender, verb form, preposition or word choice.
- "note": correct, but a native speaker would clearly say it differently.
- "good": correct and natural. When in doubt between "good" and "note", choose "good".

Do NOT correct punctuation, capital letters, or spelling that sounds the same: they come from the
speech recognition, not from the learner. Do not invent mistakes. Never change the meaning.
Do not judge what the learner talks about or whether it fits the topic: only the German.
Keep everything that was right exactly as the learner said it.

title: at most six words naming the rule or what is good, in British English.
note: one short sentence in British English explaining why. Quote German with „…“.
english: what the learner's sentence means, in British English.
correction: for "fix" and "note", the learner's whole sentence as it should be; for "good", an empty string.
Write for the learner's level: simple words for A1 and A2.`;

const SCHEMA = {
  type: "object",
  properties: {
    kind: { type: "string", enum: ["good", "fix", "note"] },
    title: { type: "string" },
    note: { type: "string" },
    english: { type: "string" },
    correction: { type: "string" },
  },
  required: ["kind", "title", "note", "english", "correction"],
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
  const sentence = clean(body.sentence, MAX_SENTENCE);
  if (!sentence) return json({ error: "bad_request" }, 400);
  const previous = clean(body.previous, MAX_SENTENCE);
  const context = clean(body.context, MAX_CONTEXT);
  const level = cefr(body.level);

  const claimed = await claim(admin, "german_checks", userId, { perUser: PER_USER_DAILY, global: GLOBAL_DAILY });
  if (claimed.status !== "ok") return refused(claimed.status);

  const input = [
    context ? `Situation or topic: ${context}` : "",
    level ? `Learner's level (CEFR): ${level}` : "",
    previous ? `The other person just said: „${previous}“` : "",
    `The learner said: „${sentence}“`,
  ].filter(Boolean).join("\n");

  const request = () =>
    fetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: MODEL,
        instructions: INSTRUCTIONS,
        input,
        // The model thinks before it answers, and its thinking counts: 400 was too few and cut answers off.
        max_output_tokens: 2000,
        store: false,
        text: { format: { type: "json_schema", name: "sentence_check", schema: SCHEMA, strict: true } },
      }),
      signal: AbortSignal.timeout(45000),
    });
  // After a key's permissions change, OpenAI refuses some requests with 401 for a while
  // (seen for over 20 minutes). The refusal is instant, so ask again a few times.
  // Only answered checks count: a failure gives the claim back.
  const failed = async () => {
    await claimed.release();
    return json({ error: "upstream" }, 502);
  };
  let upstream: Response;
  try {
    upstream = await request();
    for (let attempt = 1; attempt < 5 && upstream.status === 401; attempt++) {
      await upstream.body?.cancel();
      upstream = await request();
    }
  } catch (error) {
    console.error("OpenAI check request failed", String(error));
    return failed();
  }
  if (!upstream.ok) {
    console.error("OpenAI check failed", upstream.status, await upstream.text());
    return failed();
  }
  const response = await upstream.json();
  // The answer is the text of the first output message.
  let result: Record<string, unknown>;
  try {
    result = JSON.parse(outputText(response) ?? "");
  } catch {
    console.error("OpenAI answer was not the expected JSON", response.status, Object.keys(response));
    return failed();
  }

  return json({
    kind: result.kind,
    title: result.title,
    note: result.note,
    english: result.english,
    correction: result.correction,
  });
}
