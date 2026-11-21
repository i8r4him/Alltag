// The checks every function must pass (#439): method, sign-in, the daily limits and giving a claim
// back when the upstream call fails.

import { assertEquals } from "jsr:@std/assert@1.0.19";
import { fake, post } from "./fake.ts";

export function sharedTests(
  name: string,
  handle: (req: Request) => Promise<Response>,
  options: { body: unknown; table: string; upstream: "openai" | "gemini" },
) {
  const run = (body: unknown = options.body, token?: string | null) => handle(post(body, token));
  const failUpstream = () => {
    fake[options.upstream] = new Response("{}", { status: 500 });
  };

  Deno.test(`${name}: only POST`, async () => {
    fake.reset();
    const response = await handle(new Request("http://functions.test/", { method: "GET" }));
    assertEquals(response.status, 405);
  });

  Deno.test(`${name}: refuses without a token`, async () => {
    fake.reset();
    const response = await run(options.body, null);
    assertEquals(response.status, 401);
    assertEquals(fake.to("/rpc/").length, 0);
  });

  Deno.test(`${name}: refuses a token Supabase doesn't know`, async () => {
    fake.reset();
    const response = await run(options.body, "someone-else");
    assertEquals(response.status, 401);
    assertEquals(fake.to("/rpc/").length, 0);
  });

  for (const status of ["daily_limit", "busy"]) {
    Deno.test(`${name}: answers 429 ${status} and asks no one`, async () => {
      fake.reset();
      fake.claim = { status, claim_id: null, is_developer: false };
      const response = await run();
      assertEquals(response.status, 429);
      assertEquals((await response.json()).error, status);
      assertEquals(fake.to("api.openai.com").length + fake.to("googleapis.com").length, 0);
    });
  }

  Deno.test(`${name}: answers 503 when the limits can't be checked`, async () => {
    fake.reset();
    fake.claimFails = true;
    const response = await run();
    assertEquals(response.status, 503);
    assertEquals((await response.json()).error, "unavailable");
  });

  Deno.test(`${name}: claims in ${options.table}`, async () => {
    fake.reset();
    failUpstream();
    await run();
    const claim = fake.to("/rpc/claim_quota")[0].body as Record<string, unknown>;
    assertEquals(claim.p_table, options.table);
  });

  Deno.test(`${name}: gives the claim back when the upstream call fails`, async () => {
    fake.reset();
    failUpstream();
    const response = await run();
    assertEquals(response.status, 502);
    assertEquals((await response.json()).error, "upstream");
    const releases = fake.to("/rpc/release_quota");
    assertEquals(releases.length, 1);
    assertEquals((releases[0].body as Record<string, unknown>).p_claim_id, 7);
  });

  Deno.test(`${name}: gives the claim back when the upstream call can't connect`, async () => {
    fake.reset();
    fake[options.upstream] = () => {
      throw new TypeError("connection refused");
    };
    const response = await run();
    assertEquals(response.status, 502);
    assertEquals(fake.to("/rpc/release_quota").length, 1);
  });
}
