// A fake Supabase, OpenAI and Google for the function tests (#439): no test touches the network.
// Import it before a handler, so the handler reads these settings when it loads.

Deno.env.set("SUPABASE_URL", "http://supabase.test");
Deno.env.set("SUPABASE_SERVICE_ROLE_KEY", "service-role-test");
Deno.env.set("OPENAI_API_KEY", "sk-test");
Deno.env.set("GEMINI_API_KEY", "gemini-test");

export const LEARNER = "11111111-1111-4111-8111-111111111111";
export const TOKEN = "learner-token";

export type Call = { url: string; method: string; headers: Headers; body: unknown };

type Answer = Response | (() => Response);

/** What the fake answers, set per test. */
export const fake = {
  calls: [] as Call[],
  claim: { status: "ok", claim_id: 7, is_developer: false } as Record<string, unknown> | null,
  claimFails: false,
  openai: null as Answer | null,
  gemini: null as Answer | null,
  reset() {
    this.calls = [];
    this.claim = { status: "ok", claim_id: 7, is_developer: false };
    this.claimFails = false;
    this.openai = null;
    this.gemini = null;
  },
  /** The calls to one place, by a part of its URL. */
  to(part: string) {
    return this.calls.filter((call) => call.url.includes(part));
  },
};

const reply = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

const answer = (value: Answer | null, name: string) => {
  if (!value) throw new Error(`The test called ${name} without setting its answer`);
  return typeof value === "function" ? value() : value.clone();
};

globalThis.fetch = async (input: string | URL | Request, init?: RequestInit) => {
  const request = new Request(input, init);
  const text = await request.text();
  let body: unknown = text;
  try {
    body = text ? JSON.parse(text) : null;
  } catch {
    // Not JSON: keep the text.
  }
  const url = request.url;
  fake.calls.push({ url, method: request.method, headers: request.headers, body });

  if (url.startsWith("http://supabase.test/auth/v1/user")) {
    return request.headers.get("Authorization") === `Bearer ${TOKEN}`
      ? reply({ id: LEARNER, aud: "authenticated", role: "authenticated", is_anonymous: true })
      : reply({ code: 401, msg: "invalid JWT" }, 401);
  }
  if (url === "http://supabase.test/rest/v1/rpc/claim_quota") {
    return fake.claimFails ? reply({ message: "database down" }, 500) : reply(fake.claim ? [fake.claim] : []);
  }
  if (url === "http://supabase.test/rest/v1/rpc/release_quota") return new Response(null, { status: 204 });
  if (url.startsWith("https://api.openai.com/")) return answer(fake.openai, "OpenAI");
  if (url.startsWith("https://generativelanguage.googleapis.com/")) return answer(fake.gemini, "Google");
  throw new Error(`Unexpected request to ${url}`);
};

/** A POST from the app, signed in unless `token` is null. */
export const post = (body: unknown, token: string | null = TOKEN) =>
  new Request("http://functions.test/", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: typeof body === "string" ? body : JSON.stringify(body),
  });

/** An OpenAI Responses answer whose output text is `result` as JSON. */
export const openAIAnswer = (result: unknown, status = "completed") =>
  reply({
    status,
    output: [{ type: "message", content: [{ type: "output_text", text: JSON.stringify(result) }] }],
    usage: { input_tokens: 10, output_tokens: 20, output_tokens_details: { reasoning_tokens: 5 } },
  });

export const upstreamError = () => reply({ error: { message: "server error" } }, 500);

/** The arguments of the one claim the handler made. */
export const claimed = () => {
  const claims = fake.to("/rpc/claim_quota");
  if (claims.length !== 1) throw new Error(`Expected one claim, got ${claims.length}`);
  return claims[0].body as Record<string, unknown>;
};

/** The body of the one request sent to OpenAI. */
export const sentToOpenAI = () => {
  const calls = fake.to("api.openai.com");
  if (calls.length !== 1) throw new Error(`Expected one OpenAI request, got ${calls.length}`);
  return calls[0].body as Record<string, unknown>;
};
