import { assertEquals, assertStringIncludes } from "jsr:@std/assert@1.0.19";
import { claimed, fake, post } from "./fake.ts";
import { handle } from "../gemini-live-session/handler.ts";
import { sharedTests } from "./shared.ts";

sharedTests("gemini-live-session", handle, {
  body: { scenario: "dentist" },
  table: "realtime_sessions",
  upstream: "gemini",
});

const token = () => new Response(JSON.stringify({ name: "auth_tokens/abc" }));
const setup = () => {
  const body = fake.to("googleapis.com")[0].body as Record<string, Record<string, unknown>>;
  return body.bidiGenerateContentSetup as Record<string, Record<string, unknown>>;
};

Deno.test("gemini-live-session: hands out a one-use token and keeps the claim", async () => {
  fake.reset();
  fake.gemini = token;
  const response = await handle(post({ scenario: "dentist", instructions: "At the dentist." }));
  assertEquals(response.status, 200);
  const answer = await response.json();
  assertEquals(answer.token, "auth_tokens/abc");
  assertEquals(claimed().p_scenario, "dentist");
  assertEquals(claimed().p_per_user, 10);
  assertEquals(claimed().p_global, 200);
  assertEquals(fake.to("/rpc/release_quota").length, 0);
  const sent = fake.to("googleapis.com")[0];
  assertEquals((sent.body as Record<string, unknown>).uses, 1);
  assertEquals(sent.headers.get("x-goog-api-key"), "gemini-test");
  const instructions = JSON.stringify(setup().systemInstruction);
  assertStringIncludes(instructions, "You are Alltag");
  assertStringIncludes(instructions, "At the dentist.");
});

Deno.test("gemini-live-session: the thinking pause stays within bounds", async () => {
  for (const [asked, kept] of [["100", 800], ["99999", 4000], ["2400", 2400], ["soon", 2000]] as const) {
    fake.reset();
    fake.gemini = token;
    await handle(post({ thinking_pause: asked }));
    const detection = setup().realtimeInputConfig.automaticActivityDetection as Record<string, unknown>;
    assertEquals(detection.silenceDurationMs, kept, `thinking_pause ${asked}`);
  }
});

Deno.test("gemini-live-session: hold to talk switches Google's turn detection off", async () => {
  fake.reset();
  fake.gemini = token;
  await handle(post({ push_to_talk: "true" }));
  assertEquals(setup().realtimeInputConfig, { automaticActivityDetection: { disabled: true } });
});

Deno.test("gemini-live-session: an answer without a token gives the claim back", async () => {
  fake.reset();
  fake.gemini = () => new Response(JSON.stringify({}));
  const response = await handle(post({}));
  assertEquals(response.status, 502);
  assertEquals(fake.to("/rpc/release_quota").length, 1);
});

Deno.test("gemini-live-session: an empty body is fine", async () => {
  fake.reset();
  fake.gemini = token;
  const response = await handle(post(""));
  assertEquals(response.status, 200);
});
