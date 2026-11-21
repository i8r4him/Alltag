import { assertEquals, assertStringIncludes } from "jsr:@std/assert@1.0.19";
import { claimed, fake, openAIAnswer, post, sentToOpenAI } from "./fake.ts";
import { handle } from "../check-german/handler.ts";
import { sharedTests } from "./shared.ts";

sharedTests("check-german", handle, {
  body: { sentence: "Am Wochenende ich gehe in den Park." },
  table: "german_checks",
  upstream: "openai",
});

const verdict = { kind: "fix", title: "Verb second", note: "…", english: "…", correction: "Am Wochenende gehe ich in den Park." };

Deno.test("check-german: answers the check and keeps the claim", async () => {
  fake.reset();
  fake.openai = openAIAnswer(verdict);
  const response = await handle(post({ sentence: "Am Wochenende ich gehe in den Park.", level: "a2" }));
  assertEquals(response.status, 200);
  assertEquals(await response.json(), verdict);
  assertEquals(fake.to("/rpc/release_quota").length, 0);
  assertEquals(claimed().p_per_user, 300);
  assertEquals(claimed().p_global, 20000);
  const sent = sentToOpenAI();
  assertEquals(sent.store, false);
  assertStringIncludes(String(sent.input), "Learner's level (CEFR): A2");
});

Deno.test("check-german: needs a sentence", async () => {
  fake.reset();
  assertEquals((await handle(post({ sentence: "   " }))).status, 400);
  assertEquals((await handle(post("not json"))).status, 400);
  assertEquals(fake.to("/rpc/claim_quota").length, 0);
});

Deno.test("check-german: cuts long input and ignores a made-up level", async () => {
  fake.reset();
  fake.openai = openAIAnswer(verdict);
  await handle(post({ sentence: "a".repeat(5000), context: "b".repeat(5000), level: "Z9" }));
  const input = String(sentToOpenAI().input);
  assertEquals(input.includes("a".repeat(501)), false);
  assertEquals(input.includes("b".repeat(401)), false);
  assertEquals(input.includes("Learner's level"), false);
});

Deno.test("check-german: an answer that isn't JSON gives the claim back", async () => {
  fake.reset();
  fake.openai = new Response(JSON.stringify({ output: [{ content: [{ type: "output_text", text: "oops" }] }] }));
  const response = await handle(post({ sentence: "Hallo" }));
  assertEquals(response.status, 502);
  assertEquals(fake.to("/rpc/release_quota").length, 1);
});
