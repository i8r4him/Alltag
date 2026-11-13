// translate — translates between German and the learner's language, with OpenAI,
// and explains the German for a learner.
//
// The OpenAI API key never leaves this function. Nothing the learner wrote is
// stored: the table `translations` keeps only who asked and when, for the limits.
//
// Request:  POST, Authorization: Bearer <Supabase access token>
//           { "text": "How do I say I'm running late?",
//             "language": "English",     (the learner's language; default English)
//             "level": "A2" }            (optional)
// Response: 200 { "german": "…", "other": "…", "source_is_german": false,
//                 "note": "…",
//                 "words":    [{ "word": "…", "grammar": "…", "meaning": "…" }],
//                 "tones":    [{ "tone": "formal" | "neutral" | "casual", "german": "…" }],
//                 "examples": [{ "german": "…", "other": "…" }] }
// Errors:   400 bad_request · 401 unauthorized · 405 method_not_allowed
//           429 daily_limit | busy · 502 upstream · 503 not_configured | unavailable

import { createClient } from "npm:@supabase/supabase-js@2";

const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY");
const MODEL = Deno.env.get("TRANSLATE_MODEL") ?? "gpt-6-luna";
/** Translations per user per rolling 24 hours. Accounts in `realtime_developers` are exempt. */
const PER_USER_DAILY = Number(Deno.env.get("TRANSLATE_PER_USER_DAILY") ?? "200");
/** Translations for everyone per rolling 24 hours — a ceiling on the OpenAI bill. */
const GLOBAL_DAILY = Number(Deno.env.get("TRANSLATE_GLOBAL_DAILY") ?? "20000");
const MAX_TEXT = 600;

const instructions = (language: string) =>
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
Keep every field short. Write for the learner's level: simple words for A1 and A2.`;

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

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

const clean = (value: unknown, limit: number) =>
  typeof value === "string" ? value.trim().slice(0, limit) : "";

Deno.serve(async (req) => {
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);
  if (!OPENAI_API_KEY) return json({ error: "not_configured" }, 503);

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const token = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return json({ error: "unauthorized" }, 401);
  const { data: { user }, error: authError } = await admin.auth.getUser(token);
  if (authError || !user) return json({ error: "unauthorized" }, 401);

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
  const level = clean(body.level, 2).toUpperCase();
  const streaming = body.stream === "true";

  const since = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();
  const [mine, everyone, developer] = await Promise.all([
    admin.from("translations").select("id", { count: "exact", head: true })
      .eq("user_id", user.id).gte("created_at", since),
    admin.from("translations").select("id", { count: "exact", head: true })
      .gte("created_at", since),
    admin.from("realtime_developers").select("user_id", { count: "exact", head: true })
      .eq("user_id", user.id),
  ]);
  if (mine.error || everyone.error) {
    console.error("Counting translations failed", mine.error ?? everyone.error);
    return json({ error: "unavailable" }, 503);
  }
  // Developer accounts skip the per-user limit; if the lookup fails, the limit applies.
  if (developer.error) console.error("Looking up the developer list failed", developer.error);
  const isDeveloper = !developer.error && (developer.count ?? 0) > 0;
  if (!isDeveloper && (mine.count ?? 0) >= PER_USER_DAILY) return json({ error: "daily_limit" }, 429);
  if ((everyone.count ?? 0) >= GLOBAL_DAILY) return json({ error: "busy" }, 429);

  const input = [
    /^(A1|A2|B1|B2|C1|C2)$/.test(level) ? `Learner's level (CEFR): ${level}` : "",
    `Text: „${text}“`,
  ].filter(Boolean).join("\n");

  const request = () =>
    fetch("https://api.openai.com/v1/responses", {
      method: "POST",
      headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: MODEL,
        stream: streaming,
        instructions: instructions(language),
        input,
        // A translation needs little thinking; low effort makes it several seconds quicker.
        reasoning: { effort: "low" },
        // The model's thinking counts against this.
        max_output_tokens: 3000,
        store: false,
        text: { format: { type: "json_schema", name: "translation", schema: SCHEMA, strict: true } },
      }),
    });
  // OpenAI sometimes refuses with 401 for a while after a key's permissions change. Ask again.
  let upstream = await request();
  for (let attempt = 1; attempt < 5 && upstream.status === 401; attempt++) {
    await upstream.body?.cancel();
    upstream = await request();
  }
  if (!upstream.ok) {
    console.error("OpenAI translation failed", upstream.status, await upstream.text());
    return json({ error: "upstream" }, 502);
  }
  if (streaming && upstream.body) {
    const { error: insertError } = await admin.from("translations").insert({ user_id: user.id });
    if (insertError) console.error("Recording the translation failed", insertError);
    // Forward OpenAI's typed events without buffering the completed answer.
    // Non-streaming callers keep the original JSON response below.
    return new Response(upstream.body, {
      headers: { "Content-Type": "text/event-stream", "Cache-Control": "no-cache" },
    });
  }
  const response = await upstream.json();
  const output = (response.output ?? [])
    .flatMap((item: { content?: { type: string; text?: string }[] }) => item.content ?? [])
    .find((part: { type: string }) => part.type === "output_text")?.text;
  let result: Record<string, unknown>;
  try {
    result = JSON.parse(output ?? "");
  } catch {
    console.error("OpenAI answer was not the expected JSON", response.status, Object.keys(response));
    return json({ error: "upstream" }, 502);
  }

  const { error: insertError } = await admin.from("translations").insert({ user_id: user.id });
  if (insertError) console.error("Recording the translation failed", insertError);

  return json(result);
});
