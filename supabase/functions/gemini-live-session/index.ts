// gemini-live-session — hands the Alltag app a short-lived token for Google's Gemini Live API,
// the second provider of the live voice (#309), next to `realtime-session` (OpenAI).
//
// The Gemini API key never leaves this function. The app signs in anonymously with Supabase,
// calls this function with its access token, and connects to the Live API with the returned
// token. The token starts one session and is locked to the model, the voice and the
// instructions set here, so the app can't change them.
//
// Request:  POST, Authorization: Bearer <Supabase access token>
//           { "scenario": "dentist", "instructions": "<scenario context>",
//             "thinking_pause": "2400",   (ms of silence before the companion answers)
//             "slower": "true" }          (all optional)
// Response: 200 { "token": "auth_tokens/…", "expires_at": 1794081234, "model": "…", "voice": "…" }
// Errors:   401 unauthorized · 405 method_not_allowed · 429 daily_limit | busy
//           502 upstream · 503 not_configured | unavailable
//
// Sessions count in `realtime_sessions`, with the same daily limits as `realtime-session`:
// a learner has one allowance for the live voice, whoever provides it.

import { createClient } from "npm:@supabase/supabase-js@2";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY");
const MODEL = Deno.env.get("GEMINI_LIVE_MODEL") ?? "gemini-3.8-live";
const VOICE = Deno.env.get("GEMINI_LIVE_VOICE") ?? "Kore";
/** Sessions per user per rolling 24 hours. Accounts in `realtime_developers` are exempt. */
const PER_USER_DAILY = Number(Deno.env.get("REALTIME_PER_USER_DAILY") ?? "10");
/** Sessions for everyone per rolling 24 hours: a ceiling on the bill. */
const GLOBAL_DAILY = Number(Deno.env.get("REALTIME_GLOBAL_DAILY") ?? "200");
/** How long the app has to connect. */
const CONNECT_SECONDS = 60;
/** How long the session may then run. An audio session ends after 15 minutes at Google's end anyway. */
const SESSION_SECONDS = 15 * 60;
const MAX_CONTEXT = 4000;

/** Always sent, so the companion stays a German tutor whatever the app adds. */
const TUTOR_INSTRUCTIONS = `You are Alltag, a warm, patient German conversation partner for learners.
Speak only German, at the learner's level, in short natural sentences.
Play the other person in the situation described below and help the learner reach their goal.
If the learner makes a mistake, keep the conversation going and model the correct form in your reply.
Stay in the role: no disclaimers, no advice outside the role, no comments about being an AI.`;

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

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
    // An empty body is fine.
  }
  const scenario = typeof body.scenario === "string" ? body.scenario.slice(0, 64) : null;
  const context = typeof body.instructions === "string" ? body.instructions.slice(0, MAX_CONTEXT) : "";
  // Learners stop mid-sentence to think: the silence before an answer is the app's, within bounds.
  const pause = Math.min(Math.max(Number(body.thinking_pause) || 2000, 800), 4000);
  const slower = body.slower === "true" || body.slower === true;

  const since = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();
  const [mine, everyone, developer] = await Promise.all([
    admin.from("realtime_sessions").select("id", { count: "exact", head: true })
      .eq("user_id", user.id).gte("created_at", since),
    admin.from("realtime_sessions").select("id", { count: "exact", head: true })
      .gte("created_at", since),
    admin.from("realtime_developers").select("user_id", { count: "exact", head: true })
      .eq("user_id", user.id),
  ]);
  if (mine.error || everyone.error) {
    console.error("Counting sessions failed", mine.error ?? everyone.error);
    return json({ error: "unavailable" }, 503);
  }
  // Developer accounts skip the per-user limit; if the lookup fails, the limit applies.
  if (developer.error) console.error("Looking up the developer list failed", developer.error);
  const isDeveloper = !developer.error && (developer.count ?? 0) > 0;
  if (!isDeveloper && (mine.count ?? 0) >= PER_USER_DAILY) return json({ error: "daily_limit" }, 429);
  if ((everyone.count ?? 0) >= GLOBAL_DAILY) return json({ error: "busy" }, 429);

  const instructions = [
    TUTOR_INSTRUCTIONS,
    slower ? "Speak slowly and clearly, with short pauses between sentences." : "",
    context,
  ].filter(Boolean).join("\n\n");
  const expiresAt = Date.now() + SESSION_SECONDS * 1000;
  let upstream: Response;
  try {
    upstream = await fetch("https://generativelanguage.googleapis.com/v1beta/auth_tokens", {
      method: "POST",
      headers: { "x-goog-api-key": GEMINI_API_KEY, "Content-Type": "application/json" },
      body: JSON.stringify({
        uses: 1,
        newSessionExpireTime: new Date(Date.now() + CONNECT_SECONDS * 1000).toISOString(),
        expireTime: new Date(expiresAt).toISOString(),
        // The session's whole setup, fixed here: the app only names the model when it connects.
        bidiGenerateContentSetup: {
          model: `models/${MODEL}`,
          generationConfig: {
            responseModalities: ["AUDIO"],
            speechConfig: { voiceConfig: { prebuiltVoiceConfig: { voiceName: VOICE } } },
          },
          systemInstruction: { parts: [{ text: instructions }] },
          inputAudioTranscription: {},
          outputAudioTranscription: {},
          realtimeInputConfig: { automaticActivityDetection: { silenceDurationMs: pause } },
        },
      }),
      signal: AbortSignal.timeout(20000),
    });
  } catch (error) {
    console.error("Gemini token request failed", String(error));
    return json({ error: "upstream" }, 502);
  }
  if (!upstream.ok) {
    console.error("Gemini token refused", upstream.status, await upstream.text());
    return json({ error: "upstream" }, 502);
  }
  const issued = await upstream.json();
  if (typeof issued.name !== "string") {
    console.error("Gemini response had no token", Object.keys(issued));
    return json({ error: "upstream" }, 502);
  }

  const { error: insertError } = await admin.from("realtime_sessions").insert({ user_id: user.id, scenario });
  if (insertError) console.error("Recording the session failed", insertError);

  return json({ token: issued.name, expires_at: Math.floor(expiresAt / 1000), model: MODEL, voice: VOICE });
});
