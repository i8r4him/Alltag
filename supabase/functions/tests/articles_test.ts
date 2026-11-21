import { assertEquals } from "jsr:@std/assert@1.0.19";
import { fake, openAIAnswer, post, sentToOpenAI } from "./fake.ts";
import { handle } from "../articles/handler.ts";
import { sharedTests } from "./shared.ts";

sharedTests("articles", handle, { body: { text: "Tisch" }, table: "translations", upstream: "openai" });

const noun = { article: "der", word: "Tisch", plural: "Tische", meaning: "table", example: "…", explanation: "…" };

Deno.test("articles: answers a lookup and keeps the claim", async () => {
  fake.reset();
  fake.openai = openAIAnswer({ nouns: [noun], note: "" });
  const response = await handle(post({ text: "Tisch" }));
  assertEquals(response.status, 200);
  assertEquals((await response.json()).nouns[0].word, "Tisch");
  assertEquals(fake.to("/rpc/release_quota").length, 0);
  assertEquals(sentToOpenAI().store, false);
});

Deno.test("articles: a practice round with too few nouns gives the claim back", async () => {
  fake.reset();
  fake.openai = openAIAnswer({ nouns: [noun], note: "" });
  const response = await handle(post({ action: "practice", level: "A1" }));
  assertEquals(response.status, 502);
  assertEquals(fake.to("/rpc/release_quota").length, 1);
});

Deno.test("articles: an unfinished answer gives the claim back", async () => {
  fake.reset();
  fake.openai = openAIAnswer({ nouns: [noun], note: "" }, "incomplete");
  const response = await handle(post({ text: "Tisch" }));
  assertEquals(response.status, 502);
  assertEquals(fake.to("/rpc/release_quota").length, 1);
});

Deno.test("articles: a lookup needs text", async () => {
  fake.reset();
  assertEquals((await handle(post({ action: "lookup" }))).status, 400);
  assertEquals(fake.to("/rpc/claim_quota").length, 0);
});
