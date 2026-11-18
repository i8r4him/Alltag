// speak-warm — makes the voice of fixed sentences (word collections, grammar rules) ahead of time,
// so their Listen buttons play at once for everyone (#422). It fills the same Storage cache as
// `speak`, with the same model, voice, style and file names, so `speak` finds them there.
//
// Not for the app. Called by `scripts/warm_speech.py` with a token whose SHA-256 is below (only
// the hash is here; whoever warms makes a new token and deploys its hash):
// POST { "texts": ["Hallo, ich bin Lena.", …] }   (header `X-Warm-Token`, 25 texts at most)
// → { "made": n, "had": n, "failed": ["…"] }
//
// Keep MODEL, VOICE, STYLE and the Gemini request in step with `speak/index.ts`.

import { createClient } from "npm:@supabase/supabase-js@2";

const GEMINI_API_KEY = Deno.env.get("SPEAK_GEMINI_API_KEY") ?? Deno.env.get("GEMINI_API_KEY");
const WARM_TOKEN_SHA256 = "7498177d2b72457b12fed7d1fdb8908bc8f3a1ac4709c24582de05794156778b";
const MODEL = Deno.env.get("SPEAK_MODEL") ?? "gemini-3.8-flash-lite-tts";
const VOICE = Deno.env.get("SPEAK_VOICE") ?? "Kore";
const MAX_TEXT = 300;
const MAX_TEXTS = 25;
/** Sentences made at the same time, to stay within Gemini's rate limit. */
const PARALLEL = Number(Deno.env.get("SPEAK_WARM_PARALLEL") ?? "5");
const BUCKET = "speech";
/** How every sentence is read. Changing it makes new cache entries (it is part of the key). */
const STYLE = "a friendly native speaker from Germany, clear standard German at a natural everyday pace";
const SAMPLE_RATE = 24000;

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

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
  if (await sha256(req.headers.get("X-Warm-Token") ?? "") !== WARM_TOKEN_SHA256) {
    return json({ error: "unauthorized" }, 401);
  }

  let body: Record<string, unknown> = {};
  try {
    body = await req.json();
  } catch {
    return json({ error: "bad_request" }, 400);
  }
  const texts = Array.isArray(body.texts)
    ? body.texts.filter((text): text is string => typeof text === "string")
      .map((text) => text.replace(/\s+/g, " ").trim())
      .filter((text) => text && text.length <= MAX_TEXT)
    : [];
  if (!texts.length || texts.length > MAX_TEXTS) return json({ error: "bad_request" }, 400);

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  let made = 0;
  let had = 0;
  const failed: string[] = [];
  const queue = [...texts];

  async function work() {
    for (let text = queue.shift(); text !== undefined; text = queue.shift()) {
      const path = `${await sha256(`${MODEL}|${VOICE}|${STYLE}|${text}`)}.wav`;
      const { data: existing } = await admin.storage.from(BUCKET).list("", { search: path, limit: 1 });
      if (existing?.some((file) => file.name === path)) {
        had += 1;
        continue;
      }
      const audio = await synthesise(text);
      if (!audio) {
        failed.push(text);
        continue;
      }
      const upload = await admin.storage.from(BUCKET)
        .upload(path, audio, { contentType: "audio/wav", upsert: true });
      if (upload.error) {
        console.error("Keeping the audio failed", upload.error);
        failed.push(text);
      } else {
        made += 1;
      }
    }
  }

  await Promise.all(Array.from({ length: Math.min(PARALLEL, texts.length) }, work));
  console.log(`Warmed ${texts.length}: made ${made}, had ${had}, failed ${failed.length}`);
  return json({ made, had, failed });
});
