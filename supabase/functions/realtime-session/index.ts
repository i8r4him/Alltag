// realtime-session — hands the Alltag app a short-lived OpenAI Realtime client secret.
//
// The OpenAI API key never leaves this function. The app signs in anonymously
// with Supabase, calls this function with its access token, and connects to the
// Realtime API with the returned secret, which expires after TOKEN_SECONDS.
//
// Request:  POST, Authorization: Bearer <Supabase access token>
//           { "scenario": "dentist", "instructions": "<scenario context>" }   (both optional)
// Response: 200 { "client_secret": "ek_…", "expires_at": 1794081234, "model": "…", "voice": "…" }
// Errors:   401 unauthorized · 405 method_not_allowed · 429 daily_limit | busy
//           502 upstream · 503 not_configured | unavailable

import { createClient } from "npm:@supabase/supabase-js@2";

const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY");
const MODEL = Deno.env.get("REALTIME_MODEL") ?? "gpt-realtime";
const VOICE = Deno.env.get("REALTIME_VOICE") ?? "marin";
/** Client secrets per user per rolling 24 hours. Accounts in `realtime_developers` are exempt. */
const PER_USER_DAILY = Number(Deno.env.get("REALTIME_PER_USER_DAILY") ?? "10");
/** Client secrets for everyone per rolling 24 hours — a ceiling on the OpenAI bill. */
const GLOBAL_DAILY = Number(Deno.env.get("REALTIME_GLOBAL_DAILY") ?? "200");
const TOKEN_SECONDS = 60;
const MAX_CONTEXT = 4000;

/** Always sent, so the companion stays a German tutor whatever the app adds. */
const TUTOR_INSTRUCTIONS = `You are Alltag, a warm, patient German conversation partner for learners.
Speak only German, at the learner's level, in short natural sentences.
Play the other person in the situation described below and help the learner reach their goal.
If the learner makes a mistake, keep the conversation going and model the correct form in your reply.`;

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

Deno.serve(async (req) => {
  if (req.method !== "POST") return json({ error: "method_not_allowed" }, 405);
  if (!OPENAI_API_KEY) return json({ error: "not_configured" }, 503);

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const token = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return json({ error: "unauthorized" }, 401);
  const { data: { user }, error: authError } = await admin.auth.getUser(token);
  if (authError || !user) return json({ error: "unauthorized" }, 401);

  let body: { scenario?: unknown; instructions?: unknown } = {};
  try {
    body = await req.json();
  } catch {
    // An empty body is fine.
  }
  const scenario = typeof body.scenario === "string" ? body.scenario.slice(0, 64) : null;
  const context = typeof body.instructions === "string" ? body.instructions.slice(0, MAX_CONTEXT) : "";

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

  const upstream = await fetch("https://api.openai.com/v1/realtime/client_secrets", {
    method: "POST",
    headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
    body: JSON.stringify({
      expires_after: { anchor: "created_at", seconds: TOKEN_SECONDS },
      session: {
        type: "realtime",
        model: MODEL,
        instructions: context ? `${TUTOR_INSTRUCTIONS}\n\n${context}` : TUTOR_INSTRUCTIONS,
        audio: { output: { voice: VOICE } },
      },
    }),
  });
  if (!upstream.ok) {
    console.error("OpenAI client secret failed", upstream.status, await upstream.text());
    return json({ error: "upstream" }, 502);
  }
  const secret = await upstream.json();
  const value = secret.value ?? secret.client_secret?.value;
  const expiresAt = secret.expires_at ?? secret.client_secret?.expires_at;
  if (typeof value !== "string") {
    console.error("OpenAI response had no client secret", Object.keys(secret));
    return json({ error: "upstream" }, 502);
  }

  const { error: insertError } = await admin.from("realtime_sessions").insert({ user_id: user.id, scenario });
  if (insertError) console.error("Recording the session failed", insertError);

  return json({ client_secret: value, expires_at: expiresAt, model: MODEL, voice: VOICE });
});
