import { assertEquals } from "jsr:@std/assert@1.0.19";
import { claimed, fake, openAIAnswer, post, sentToOpenAI } from "./fake.ts";
import { handle } from "../write/handler.ts";
import { sharedTests } from "./shared.ts";

const chat = (messages: unknown[]) => JSON.stringify(messages);
const chatBody = {
  action: "chat",
  level: "B1",
  contact: "lena",
  messages: chat([{ from: "Lena", text: "Hey! Kino heute?" }, { from: "me", text: "ja klar, wann?" }]),
};

sharedTests("write (check)", handle, {
  body: { action: "check", level: "B1", text: "Ich habe gestern ins Kino gegangen." },
  table: "german_checks",
  upstream: "openai",
});
sharedTests("write (chat)", handle, { body: chatBody, table: "german_checks", upstream: "openai" });
sharedTests("write (questions)", handle, {
  body: { action: "questions", level: "B1", title: "Mieten", text: "Die Mieten steigen. ".repeat(10) },
  table: "translations",
  upstream: "openai",
});

const chatAnswer = {
  replies: [1, 2, 3, 4].map((n) => ({ from: "Lena", text: `Nachricht ${n}`, english: "…" })),
  check: { kind: "good", title: "Fine", note: "…", correction: "", english: "…" },
};

Deno.test("write: a chat answers at most three messages and keeps the claim", async () => {
  fake.reset();
  fake.openai = openAIAnswer(chatAnswer);
  const response = await handle(post(chatBody));
  assertEquals(response.status, 200);
  assertEquals((await response.json()).replies.length, 3);
  assertEquals(claimed().p_per_user, 300);
  assertEquals(fake.to("/rpc/release_quota").length, 0);
  assertEquals(sentToOpenAI().model, "gpt-6-luna");
  assertEquals(sentToOpenAI().store, false);
});

Deno.test("write: the last chat message must be the learner's", async () => {
  fake.reset();
  const lastFromLena = { ...chatBody, messages: chat([{ from: "me", text: "hi" }, { from: "Lena", text: "Hey!" }]) };
  assertEquals((await handle(post(lastFromLena))).status, 400);
  assertEquals((await handle(post({ ...chatBody, contact: "stranger" }))).status, 400);
  assertEquals((await handle(post({ ...chatBody, messages: "not json" }))).status, 400);
  assertEquals(fake.to("/rpc/claim_quota").length, 0);
});

Deno.test("write: only developers may choose the model", async () => {
  fake.reset();
  fake.openai = openAIAnswer(chatAnswer);
  await handle(post({ ...chatBody, model: "gpt-6.1-sol", effort: "high" }));
  assertEquals(sentToOpenAI().model, "gpt-6-luna");
  assertEquals(sentToOpenAI().reasoning, { effort: "low" });

  fake.reset();
  fake.claim = { status: "ok", claim_id: 7, is_developer: true };
  fake.openai = openAIAnswer(chatAnswer);
  await handle(post({ ...chatBody, model: "gpt-6.1-sol", effort: "high" }));
  assertEquals(sentToOpenAI().model, "gpt-6.1-sol");
  assertEquals(sentToOpenAI().reasoning, { effort: "high" });

  fake.reset();
  fake.claim = { status: "ok", claim_id: 7, is_developer: true };
  fake.openai = openAIAnswer(chatAnswer);
  await handle(post({ ...chatBody, model: "gpt-9-anything" }));
  assertEquals(sentToOpenAI().model, "gpt-6-luna");
});

Deno.test("write: a streamed check is forwarded and counts", async () => {
  fake.reset();
  fake.openai = new Response("data: {}\n\n", { headers: { "Content-Type": "text/event-stream" } });
  const response = await handle(post({ action: "check", level: "B1", text: "Hallo.", stream: "true" }));
  assertEquals(response.headers.get("Content-Type"), "text/event-stream");
  await response.text();
  assertEquals(fake.to("/rpc/release_quota").length, 0);
});

Deno.test("write: unknown actions and short articles are refused before claiming", async () => {
  fake.reset();
  assertEquals((await handle(post({ action: "poem" }))).status, 400);
  assertEquals((await handle(post({ action: "questions", text: "Zu kurz." }))).status, 400);
  assertEquals((await handle(post({ action: "check", text: "" }))).status, 400);
  assertEquals(fake.to("/rpc/claim_quota").length, 0);
});

Deno.test("write: an unfinished answer gives the claim back", async () => {
  fake.reset();
  fake.openai = openAIAnswer(chatAnswer, "incomplete");
  const response = await handle(post(chatBody));
  assertEquals(response.status, 502);
  assertEquals(fake.to("/rpc/release_quota").length, 1);
});
