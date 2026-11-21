// gemini-live-session — hands the Alltag app a short-lived token for Google's Gemini Live API,
// the live voice (#309).
//
// The Gemini API key never leaves this function. The app signs in anonymously with Supabase,
// calls this function with its access token, and connects to the Live API with the returned
// token. The token starts one session and is locked to the model, the voice and the
// instructions set here, so the app can't change them.
//
// Request:  POST, Authorization: Bearer <Supabase access token>
//           { "scenario": "dentist", "instructions": "<scenario context>",
//             "thinking_pause": "2400",   (ms of silence before the companion answers)
//             "slower": "true",
//             "push_to_talk": "true" }    (hold to talk: the app marks each turn; all optional)
// Response: 200 { "token": "auth_tokens/…", "expires_at": 1794081234, "model": "…", "voice": "…" }
// Errors:   401 unauthorized · 405 method_not_allowed · 429 daily_limit | busy
//           502 upstream · 503 not_configured | unavailable
//
// Sessions count in `realtime_sessions` (the name is from the old OpenAI voice).

import { claim, envNumber, json, refused, serviceClient, signedInUser } from "../_shared/server.ts";

const GEMINI_API_KEY = Deno.env.get("GEMINI_API_KEY");
const MODEL = Deno.env.get("GEMINI_LIVE_MODEL") ?? "gemini-3.8-live";
const VOICE = Deno.env.get("GEMINI_LIVE_VOICE") ?? "Kore";
/** Sessions per user per rolling 24 hours. Accounts in `realtime_developers` are exempt. */
const PER_USER_DAILY = envNumber("REALTIME_PER_USER_DAILY", 10);
/** Sessions for everyone per rolling 24 hours: a ceiling on the bill. */
const GLOBAL_DAILY = envNumber("REALTIME_GLOBAL_DAILY", 200);
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

export async function handle(req: Request): Promise<Response> {
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);
  if (!GEMINI_API_KEY) return json({ error: "not_configured" }, 503);

  const admin = serviceClient();
  const userId = await signedInUser(admin, req);
  if (!userId) return json({ error: "unauthorized" }, 401);

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
  // Hold to talk: Google doesn't listen for pauses; the app sends activityStart and activityEnd.
  const pushToTalk = body.push_to_talk === "true" || body.push_to_talk === true;

  const claimed = await claim(
    admin,
    "realtime_sessions",
    userId,
    { perUser: PER_USER_DAILY, global: GLOBAL_DAILY },
    scenario,
  );
  if (claimed.status !== "ok") return refused(claimed.status);
  // Only sessions that got a token count: a failure gives the claim back.
  const failed = async () => {
    await claimed.release();
    return json({ error: "upstream" }, 502);
  };

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
          realtimeInputConfig: pushToTalk
            ? { automaticActivityDetection: { disabled: true } }
            : { automaticActivityDetection: { silenceDurationMs: pause } },
        },
      }),
      signal: AbortSignal.timeout(20000),
    });
  } catch (error) {
    console.error("Gemini token request failed", String(error));
    return failed();
  }
  if (!upstream.ok) {
    console.error("Gemini token refused", upstream.status, await upstream.text());
    return failed();
  }
  const issued = await upstream.json();
  if (typeof issued.name !== "string") {
    console.error("Gemini response had no token", Object.keys(issued));
    return failed();
  }

  return json({ token: issued.name, expires_at: Math.floor(expiresAt / 1000), model: MODEL, voice: VOICE });
}
