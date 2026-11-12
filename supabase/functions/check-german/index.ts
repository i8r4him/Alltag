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

import { createClient } from "npm:@supabase/supabase-js@2";

const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY");
const MODEL = Deno.env.get("CHECK_MODEL") ?? "gpt-6.1-terra";
/** Sentences per user per rolling 24 hours. Accounts in `realtime_developers` are exempt. */
const PER_USER_DAILY = Number(Deno.env.get("CHECK_PER_USER_DAILY") ?? "300");
/** Sentences for everyone per rolling 24 hours — a ceiling on the OpenAI bill. */
const GLOBAL_DAILY = Number(Deno.env.get("CHECK_GLOBAL_DAILY") ?? "20000");
const MAX_SENTENCE = 500;
const MAX_CONTEXT = 400;

const INSTRUCTIONS = `You are Alltag, a warm and precise German tutor.
A learner SAID the sentence below out loud; speech recognition wrote it down.
Judge only that sentence, as spoken German.

kind:
- "fix": a real mistake in grammar, word order, case, gender, verb form, preposition or word choice.
- "note": correct, but a native speaker would say it differently, or it does not fit the situation.
- "good": correct and natural. When in doubt between "good" and "note", choose "good".

Do NOT correct punctuation, capital letters, or spelling that sounds the same: they come from the
speech recognition, not from the learner. Do not invent mistakes. Never change the meaning.
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

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

const text = (value: unknown, limit: number) =>
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
  const sentence = text(body.sentence, MAX_SENTENCE);
  if (!sentence) return json({ error: "bad_request" }, 400);
  const previous = text(body.previous, MAX_SENTENCE);
  const context = text(body.context, MAX_CONTEXT);
  const level = text(body.level, 2).toUpperCase();

  const since = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();
  const [mine, everyone, developer] = await Promise.all([
    admin.from("german_checks").select("id", { count: "exact", head: true })
      .eq("user_id", user.id).gte("created_at", since),
    admin.from("german_checks").select("id", { count: "exact", head: true })
      .gte("created_at", since),
    admin.from("realtime_developers").select("user_id", { count: "exact", head: true })
      .eq("user_id", user.id),
  ]);
  if (mine.error || everyone.error) {
    console.error("Counting checks failed", mine.error ?? everyone.error);
    return json({ error: "unavailable" }, 503);
  }
  // Developer accounts skip the per-user limit; if the lookup fails, the limit applies.
  if (developer.error) console.error("Looking up the developer list failed", developer.error);
  const isDeveloper = !developer.error && (developer.count ?? 0) > 0;
  if (!isDeveloper && (mine.count ?? 0) >= PER_USER_DAILY) return json({ error: "daily_limit" }, 429);
  if ((everyone.count ?? 0) >= GLOBAL_DAILY) return json({ error: "busy" }, 429);

  const input = [
    context ? `Situation or topic: ${context}` : "",
    /^(A1|A2|B1|B2|C1|C2)$/.test(level) ? `Learner's level (CEFR): ${level}` : "",
    previous ? `The other person just said: „${previous}“` : "",
    `The learner said: „${sentence}“`,
  ].filter(Boolean).join("\n");

  const upstream = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
    body: JSON.stringify({
      model: MODEL,
      instructions: INSTRUCTIONS,
      input,
      max_output_tokens: 400,
      store: false,
      text: { format: { type: "json_schema", name: "sentence_check", schema: SCHEMA, strict: true } },
    }),
  });
  if (!upstream.ok) {
    console.error("OpenAI check failed", upstream.status, await upstream.text());
    return json({ error: "upstream" }, 502);
  }
  const response = await upstream.json();
  // The answer is the text of the first output message.
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

  const { error: insertError } = await admin.from("german_checks").insert({ user_id: user.id });
  if (insertError) console.error("Recording the check failed", insertError);

  return json({
    kind: result.kind,
    title: result.title,
    note: result.note,
    english: result.english,
    correction: result.correction,
  });
});
