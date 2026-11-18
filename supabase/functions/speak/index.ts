// speak — turns a short German text into natural speech with Google's Gemini TTS, for every
// Listen button in the app (#422). It replaces the iPhone's own voice.
//
// The Gemini API key never leaves this function. `SPEAK_GEMINI_API_KEY` is its own key (from its
// own Google project, so its cost shows on its own); without it the live voice's `GEMINI_API_KEY`.
// Each sentence is made once and kept in the private Storage bucket `speech`, named by a hash of
// the model, the voice and the text, so the same sentence is free for everyone after the first
// time. The cache holds only audio of the text, never who asked for it.
//
// Request:  POST, Authorization: Bearer <Supabase access token>
//           { "text": "Der Zug fährt heute von Gleis 12." }   (300 characters at most)
// Response: 200 audio/wav (24 kHz, mono, 16-bit), header `X-Alltag-Cache: hit | miss`
// Errors:   400 bad_request · 401 unauthorized · 405 method_not_allowed
//           429 daily_limit | busy · 502 upstream · 503 not_configured | unavailable
//
// Only new sentences count towards the limits (table `speech_requests`: who and when).

import { createClient } from "npm:@supabase/supabase-js@2";

declare const EdgeRuntime: { waitUntil(promise: Promise<unknown>): void };

const GEMINI_API_KEY = Deno.env.get("SPEAK_GEMINI_API_KEY") ?? Deno.env.get("GEMINI_API_KEY");
const MODEL = Deno.env.get("SPEAK_MODEL") ?? "gemini-3.8-flash-lite-tts";
const VOICE = Deno.env.get("SPEAK_VOICE") ?? "Kore";
/** New sentences per user per rolling 24 hours. Accounts in `realtime_developers` are exempt. */
const PER_USER_DAILY = Number(Deno.env.get("SPEAK_PER_USER_DAILY") ?? "300");
/** New sentences for everyone per rolling 24 hours: a ceiling on the bill. */
const GLOBAL_DAILY = Number(Deno.env.get("SPEAK_GLOBAL_DAILY") ?? "20000");
const MAX_TEXT = 300;
const BUCKET = "speech";
/** How every sentence is read. Changing it makes new cache entries (it is part of the key). */
const STYLE = "a friendly native speaker from Germany, clear standard German at a natural everyday pace";
const SAMPLE_RATE = 24000;

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

const wav = (audio: Uint8Array, cache: "hit" | "miss") =>
  new Response(audio, {
    headers: { "Content-Type": "audio/wav", "X-Alltag-Cache": cache, "Cache-Control": "private, max-age=31536000" },
  });

async function sha256(text: string) {
  const digest = await crypto.subtle.digest("SHA-256", new TextEncoder().encode(text));
  return [...new Uint8Array(digest)].map((byte) => byte.toString(16).padStart(2, "0")).join("");
}

/** Returns the last base64 audio block anywhere in an answer, whatever its exact shape. */
function findAudio(node: unknown): string | undefined {
  let found: string | undefined;
  if (Array.isArray(node)) {
    for (const value of node) found = findAudio(value) ?? found;
  } else if (node && typeof node === "object") {
    const record = node as Record<string, unknown>;
    if (record.type === "audio" && typeof record.data === "string") found = record.data;
    const inline = record.inlineData as Record<string, unknown> | undefined;
    if (inline && typeof inline.data === "string") found = inline.data;
    for (const value of Object.values(record)) found = findAudio(value) ?? found;
  }
  return found;
}

const decode = (base64: string) => Uint8Array.from(atob(base64), (char) => char.charCodeAt(0));

/** Puts a WAV header in front of raw 16-bit mono PCM, unless it already has one ("RIFF"). */
function asWav(audio: Uint8Array): Uint8Array {
  if (audio.length > 12 && String.fromCharCode(...audio.slice(0, 4)) === "RIFF") return audio;
  const header = new DataView(new ArrayBuffer(44));
  const ascii = (offset: number, text: string) =>
    [...text].forEach((char, index) => header.setUint8(offset + index, char.charCodeAt(0)));
  ascii(0, "RIFF");
  header.setUint32(4, 36 + audio.length, true);
  ascii(8, "WAVE");
  ascii(12, "fmt ");
  header.setUint32(16, 16, true);
  header.setUint16(20, 1, true); // PCM
  header.setUint16(22, 1, true); // mono
  header.setUint32(24, SAMPLE_RATE, true);
  header.setUint32(28, SAMPLE_RATE * 2, true);
  header.setUint16(32, 2, true);
  header.setUint16(34, 16, true);
  ascii(36, "data");
  header.setUint32(40, audio.length, true);
  const result = new Uint8Array(44 + audio.length);
  result.set(new Uint8Array(header.buffer), 0);
  result.set(audio, 44);
  return result;
}

/** Asks Gemini for the audio: the Interactions API first, generateContent if that refuses. */
async function synthesise(text: string): Promise<Uint8Array | undefined> {
  const headers = { "x-goog-api-key": GEMINI_API_KEY!, "Content-Type": "application/json" };
  const interactions = await fetch("https://generativelanguage.googleapis.com/v1beta/interactions", {
    method: "POST",
    headers,
    body: JSON.stringify({
      model: MODEL,
      input: [{
        type: "user_input",
        content: [{ type: "text", text, annotations: [{ type: "speech_metadata", style: STYLE }] }],
      }],
      response_format: { type: "audio" },
      generation_config: { speech_config: [{ voice: VOICE }] },
    }),
  });
  if (interactions.ok) {
    const audio = findAudio(await interactions.json());
    if (audio) return asWav(decode(audio));
    console.error("Gemini interactions answer had no audio");
  } else {
    console.error("Gemini interactions failed", interactions.status, (await interactions.text()).slice(0, 500));
    // Over the rate limit (10 a minute on Tier 1): asking the other way would only count again.
    if (interactions.status === 429) return undefined;
  }

  const generate = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`,
    {
      method: "POST",
      headers,
      body: JSON.stringify({
        contents: [{ parts: [{ text: `Say it as ${STYLE}: ${text}` }] }],
        generationConfig: {
          responseModalities: ["AUDIO"],
          speechConfig: { voiceConfig: { prebuiltVoiceConfig: { voiceName: VOICE } } },
        },
      }),
    },
  );
  if (!generate.ok) {
    console.error("Gemini generateContent failed", generate.status, (await generate.text()).slice(0, 500));
    return undefined;
  }
  const audio = findAudio(await generate.json());
  if (!audio) console.error("Gemini generateContent answer had no audio");
  return audio ? asWav(decode(audio)) : undefined;
}

Deno.serve(async (req) => {
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);
  if (!GEMINI_API_KEY) return json({ error: "not_configured" }, 503);

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
  // The same sentence with other spaces is the same sentence, and the same cache entry.
  const text = typeof body.text === "string" ? body.text.replace(/\s+/g, " ").trim() : "";
  if (!text || text.length > MAX_TEXT) return json({ error: "bad_request" }, 400);

  const path = `${await sha256(`${MODEL}|${VOICE}|${STYLE}|${text}`)}.wav`;
  const cached = await admin.storage.from(BUCKET).download(path);
  if (cached.data) return wav(new Uint8Array(await cached.data.arrayBuffer()), "hit");

  const since = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();
  const [mine, everyone, developer] = await Promise.all([
    admin.from("speech_requests").select("id", { count: "exact", head: true })
      .eq("user_id", user.id).gte("created_at", since),
    admin.from("speech_requests").select("id", { count: "exact", head: true })
      .gte("created_at", since),
    admin.from("realtime_developers").select("user_id", { count: "exact", head: true })
      .eq("user_id", user.id),
  ]);
  if (mine.error || everyone.error) {
    console.error("Counting speech requests failed", mine.error ?? everyone.error);
    return json({ error: "unavailable" }, 503);
  }
  // Developer accounts skip the per-user limit; if the lookup fails, the limit applies.
  if (developer.error) console.error("Looking up the developer list failed", developer.error);
  const isDeveloper = !developer.error && (developer.count ?? 0) > 0;
  if (!isDeveloper && (mine.count ?? 0) >= PER_USER_DAILY) return json({ error: "daily_limit" }, 429);
  if ((everyone.count ?? 0) >= GLOBAL_DAILY) return json({ error: "busy" }, 429);

  const started = Date.now();
  const audio = await synthesise(text);
  if (!audio) return json({ error: "upstream" }, 502);
  console.log(`Gemini made ${text.length} characters in ${Date.now() - started} ms`);

  // The learner hears the audio at once; keeping it and counting it happen after the answer.
  // When keeping it fails, the next request makes it again.
  const keep = Promise.all([
    admin.storage.from(BUCKET).upload(path, audio, { contentType: "audio/wav", upsert: true }),
    admin.from("speech_requests").insert({ user_id: user.id }),
  ]).then(([upload, insert]) => {
    if (upload.error) console.error("Keeping the audio failed", upload.error);
    if (insert.error) console.error("Recording the speech request failed", insert.error);
  });
  EdgeRuntime.waitUntil(keep);

  return wav(audio, "miss");
});
