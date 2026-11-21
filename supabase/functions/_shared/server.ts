// What every function shares (#439): the answer helpers, the signed-in learner and the daily limits.
//
// The limits are claimed in the database in one step (`claim_quota`, migration 20261121100000), so
// two requests at the same moment can't both pass a limit. A claim is made before the upstream call
// and given back (`release`) when that call fails, so only answered requests count.

import { createClient, type SupabaseClient } from "npm:@supabase/supabase-js@2.119.0";

export type QuotaTable = "realtime_sessions" | "german_checks" | "translations";

export const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

/** A string from the request, trimmed and cut to `limit` characters; anything else is "". */
export const clean = (value: unknown, limit: number) =>
  typeof value === "string" ? value.trim().slice(0, limit) : "";

/** The CEFR level if it is one, otherwise "". */
export const cefr = (value: unknown) => {
  const level = clean(value, 2).toUpperCase();
  return /^(A1|A2|B1|B2|C1|C2)$/.test(level) ? level : "";
};

/** A client with the service role: it may read and write the limit tables, which the app can't. */
export const serviceClient = () =>
  createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!, {
    auth: { persistSession: false, autoRefreshToken: false },
  });

/** The learner's id from the request's Supabase access token, or null. */
export async function signedInUser(admin: SupabaseClient, req: Request): Promise<string | null> {
  const token = req.headers.get("Authorization")?.replace(/^Bearer\s+/i, "");
  if (!token) return null;
  const { data, error } = await admin.auth.getUser(token);
  return error || !data.user ? null : data.user.id;
}

export type Claim =
  | { status: "ok"; isDeveloper: boolean; release: () => Promise<void> }
  | { status: "daily_limit" | "busy" | "unavailable"; isDeveloper: boolean };

/**
 * Claims one request of today's allowance in `table`: per learner per rolling 24 hours, and for
 * everyone together. Accounts in `realtime_developers` skip the per-learner limit.
 */
export async function claim(
  admin: SupabaseClient,
  table: QuotaTable,
  userId: string,
  limits: { perUser: number; global: number },
  scenario: string | null = null,
): Promise<Claim> {
  const { data, error } = await admin.rpc("claim_quota", {
    p_table: table,
    p_user: userId,
    p_per_user: limits.perUser,
    p_global: limits.global,
    p_scenario: scenario,
  });
  const row = Array.isArray(data) ? data[0] : data;
  if (error || !row) {
    console.error("Claiming the daily allowance failed", error);
    return { status: "unavailable", isDeveloper: false };
  }
  const isDeveloper = row.is_developer === true;
  if (row.status !== "ok") {
    return { status: row.status === "busy" ? "busy" : "daily_limit", isDeveloper };
  }
  return {
    status: "ok",
    isDeveloper,
    release: async () => {
      const { error } = await admin.rpc("release_quota", { p_table: table, p_claim_id: row.claim_id, p_user: userId });
      if (error) console.error("Giving the claim back failed", error);
    },
  };
}

/** The answer for a claim that was refused. */
export const refused = (status: "daily_limit" | "busy" | "unavailable") =>
  json({ error: status }, status === "unavailable" ? 503 : 429);

/** The text of the first output message of an OpenAI Responses answer. */
export const outputText = (response: { output?: { content?: { type: string; text?: string }[] }[] }) =>
  (response.output ?? [])
    .flatMap((item) => item.content ?? [])
    .find((part) => part.type === "output_text")?.text;

/** A number from the environment, or the default when it isn't set. */
export const envNumber = (name: string, fallback: number) => Number(Deno.env.get(name) ?? String(fallback));
