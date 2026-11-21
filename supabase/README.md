# Alltag backend (Supabase)

The project is `Alltag` (ref `flbymqlcauvwumznvviq`, region eu-central-1, free plan).
Its only job is to keep the API keys off the phone: Google's for the live voice, OpenAI's for checking sentences, translating and articles.

```
App ──(Supabase anonymous session)──▶ gemini-live-session ──(GEMINI_API_KEY)──▶ Google
App ◀── short-lived token (one session, within a minute) ──┘
App ──(token)──▶ Gemini Live API (audio both ways)
```

The live voice is Gemini only (#309). The old OpenAI voice function, `realtime-session`, was switched off on 21 Nov 2026 (it answers 410) and left the repo; it can be deleted from the dashboard, like `write-trial`.

## Public values (fine to ship in the app)

| | |
|---|---|
| URL | `https://flbymqlcauvwumznvviq.supabase.co` |
| Publishable key | `sb_publishable_b26lEqjEmiwWbQYZ-EO4QQ_d5OB-mUV` |

## The app's side

1. **Sign in anonymously once.** Send `POST {URL}/auth/v1/signup` with the headers `apikey: <publishable key>` and `Content-Type: application/json`, and the body `{}`.
   - It returns `access_token`, `refresh_token` and `expires_in`. Keep them in the Keychain.
   - To refresh, send `POST {URL}/auth/v1/token?grant_type=refresh_token` with `{"refresh_token": "…"}` and the same `apikey` header.
2. **Ask for a token** for each conversation.
   - Send `POST {URL}/functions/v1/gemini-live-session` with the headers `Authorization: Bearer <access_token>` and `apikey: <publishable key>`.
   - The body and the answer are described under "Live voice with Gemini" below.
   - The errors are listed in the next table.
3. **Connect to the Gemini Live API** with the token before it expires. Check the endpoint and message names against Google's current Live API docs.

| Status | `error` | Meaning |
|---|---|---|
| 401 | `unauthorized` | No or expired Supabase token. Refresh it and retry once. |
| 429 | `daily_limit` | This learner used today's sessions (`REALTIME_PER_USER_DAILY`, default 10). Developer accounts are exempt (see below). |
| 429 | `busy` | Everyone together reached `REALTIME_GLOBAL_DAILY` (default 200). |
| 502 | `upstream` | Google (or OpenAI, for the text functions) refused. Check the function logs. |
| 503 | `not_configured` / `unavailable` | No API key set (`GEMINI_API_KEY` or `OPENAI_API_KEY`), or the database is unreachable. |

## Secrets (set by the maintainer, never committed)

Set them in the dashboard (Edge Functions → Secrets) or with the CLI:

```sh
supabase secrets set --project-ref flbymqlcauvwumznvviq GEMINI_API_KEY=… OPENAI_API_KEY=sk-…
# optional
supabase secrets set --project-ref flbymqlcauvwumznvviq GEMINI_LIVE_MODEL=gemini-3.8-live GEMINI_LIVE_VOICE=Kore \
  REALTIME_PER_USER_DAILY=10 REALTIME_GLOBAL_DAILY=200
```

Required dashboard setting: under **Authentication → Sign In / Providers**, turn on **Allow anonymous sign-ins**.

## Limits and cost

- A token is only valid for starting one session. Once connected, a Gemini Live session runs until the app closes it, and 15 minutes at most.
  - Close sessions in the app when the conversation ends, and after about 10 minutes at most.
  - The daily counts cap how many sessions can start.
- Anonymous accounts are free to create, so the global cap is the real ceiling on the bill.
  - Before a public release, add App Attest (needs the paid developer account) or a captcha on sign-in.
  - Set a monthly budget limit in the OpenAI dashboard.
- The table `realtime_sessions` has RLS on and no policies, so only the function (service role) can read or write it.

### How the limits are counted

Each function claims one request of the day's allowance **before** it asks OpenAI or Google, with the database function `claim_quota` (migration `20261121100000_claim_quota.sql`, #439). It takes a lock per table, counts the last 24 hours and inserts the row in one transaction, so two requests at the same moment can't both pass a limit. When the upstream call fails, the function gives the claim back (`release_quota`), so only answered requests count. Only the service role may call either; the app can't. The shared code is `functions/_shared/server.ts`.

### No daily limit while developing

Accounts listed in `realtime_developers` skip the **per-user** limit. The global limit still applies to them.

- Find your account: it's the `user_id` with the most recent rows in `realtime_sessions` after you start a conversation on your device. The app keeps it in the Keychain, so it survives reinstalling.
- Add it in the SQL editor:
  ```sql
  insert into public.realtime_developers (user_id, note) values ('<user id>', 'Ibrahim’s iPhone');
  ```
- Remove the row to get the normal limit back. The app can't read or change this table.

## Checking a sentence (`check-german`)

The mistake check after 60 seconds and after conversations. The app sends **text only**, one sentence at a time, never audio.

- Send `POST {URL}/functions/v1/check-german` with the same two headers as above.
- The body is `{"sentence": "…", "previous": "…", "context": "…", "level": "A2"}`. Only `sentence` is required (500 characters at most).
- `200` returns `{"kind": "good" | "fix" | "note", "title": "…", "note": "…", "english": "…", "correction": "…"}`.
- The errors are the same as in the table above, plus `400 bad_request` for a missing sentence.
- **Nothing the learner said is stored.** The table `german_checks` keeps only who asked and when, for the limits: `CHECK_PER_USER_DAILY` (default 300 sentences) and `CHECK_GLOBAL_DAILY` (default 20,000). Developer accounts skip the per-user limit.
- The model is `CHECK_MODEL` (default `gpt-6-luna`, OpenAI's most efficient model). The request is sent with `store: false`.
- **The OpenAI key needs the Responses permission.** A key restricted to Realtime answers `401 Missing scopes: api.responses.write`, the function answers `502 upstream`, and the app checks on the device instead. Give the key "Responses: Write" in the OpenAI dashboard (API keys → edit the key → Permissions).

## Translating (`translate`)

Translate and "How do I say …?" in the app. Text only.

- Send `POST {URL}/functions/v1/translate` with the same two headers as above.
- The body is `{"text": "…", "language": "English", "level": "B1"}`. Only `text` is required (600 characters at most). `language` is the learner's own language, by its English name.
- German text is translated into the learner's language; anything else into natural everyday German.
- `register` (optional, sent by "How do I say …?") chooses how the German sounds: `"everyday"` is spoken Umgangssprache with *du*, `"formal"` is polite written German with *Sie* (an email with greeting and closing). Without it, or with any other value, nothing changes, so Translate and the translation panel keep the translator's German.
- `200` returns `{"german", "other", "source_is_german", "note", "words": [{word, grammar, meaning}], "tones": [{tone, german}], "examples": [{german, other}]}`.
- **Nothing the learner wrote is stored.** The table `translations` keeps only who asked and when, for the limits: `TRANSLATE_PER_USER_DAILY` (default 200) and `TRANSLATE_GLOBAL_DAILY` (default 20,000). Developer accounts skip the per-user limit.
- Set `stream` to the string `"true"` to receive OpenAI server-sent events as the answer is generated; without it, the function retains its JSON response for older app versions. Streaming requests count towards the quota when OpenAI accepts them.
- The model is `TRANSLATE_MODEL` (default `gpt-6-luna`), asked for **low reasoning effort**: about 3 seconds an answer instead of 5 to 10. Sent with `store: false`.
- It needs the same Responses permission on the OpenAI key as `check-german`.

## Writing (`write`)

Learn › Write in the app: the check of a text and the friends in its chats; and the questions about an article in Learn › Read. Text only; the request and answer of each action are at the top of `functions/write/index.ts`.

- `check` marks a formal email, a text about a topic or a form sentence by sentence, against the task the app sends (`task`). With `stream: "true"` it forwards OpenAI's events, so the app shows each sentence as soon as it is checked. Model `WRITE_CHECK_MODEL` (default `gpt-6.1-terra`, low effort).
- `chat` (v9, 19 Nov 2026, #427) plays Lena, the WG group (Mia and Tobi) or Jonas: `contact` is `lena`, `wg` or `jonas`, `messages` the chat so far as a JSON string (the last message is the learner's), `wrap_up: "true"` ends it. It answers with one to three short casual messages at the learner's level and a check of the learner's last message that treats texting German (lowercase, "hab", no full stop) as correct and too formal German as a tip. Model `WRITE_CHAT_MODEL` (default `gpt-6-luna`, low effort), not streamed.
- `task` writes a new task (unused by the app since #427; kept for later).
- `questions` (v10, 19 Nov 2026, #269) writes three multiple-choice questions about an article from the web for Learn › Read: `article` (its title and paragraphs, at most 15,000 characters) and `level`. It answers the questions (prompt, three options, the answer and the sentence it rests on), the article's level and its gist in one line. Model `WRITE_TASK_MODEL` (default `gpt-6-luna`), not streamed.
- **Nothing the learner wrote is stored.** A check and a chat reply count in `german_checks`, a task and questions in `translations`, with the same limits as `check-german` and `translate`.

## Files

Each function is `functions/<name>/index.ts` (the entry point, one line) and `handler.ts` (the code and its notes), so the tests can import the handler. `config.toml` keeps JWT verification on for every function; deploy with the CLI from `supabase/` (`supabase functions deploy <name>`), which reads it and bundles `_shared/`.

- `functions/gemini-live-session/`: the live voice (Google's Gemini Live).
- `functions/check-german/`: the sentence check.
- `functions/translate/`: translating.
- `functions/write/`: Learn › Write's checks and chats, and Read's questions.
- `functions/articles/`: Articles' lookups and practice rounds.
- `functions/_shared/server.ts`: the sign-in, the daily limits and the answer helpers every function uses.
- `functions/tests/`: Deno tests for every function, with OpenAI, Google and Supabase stubbed (`fake.ts`); no network, no keys.
- `tests/run_sql_tests.sh`: applies every migration to an empty Postgres and tests `claim_quota`. It drops the `public` schema, so it only runs with `ALLTAG_SQL_TEST_DB=1`, and never against the project.
- `migrations/20261121100000_claim_quota.sql`: claiming and giving back the daily allowance in one step.
- `migrations/20261107200000_realtime_sessions.sql`: the session log used for the limits.
- `migrations/20261111100000_realtime_developers.sql`: the accounts that skip the per-user limit.
- `migrations/20261113100000_german_checks.sql`: the check log used for the limits.
- `migrations/20261113120000_translations.sql`: the translation log used for the limits.

## Articles (`articles`)

Authenticated OpenAI noun lookup (`action: lookup`, `text`) and random practice batches (`action: practice`, `level`, optional recent `exclude` words). Uses `ARTICLES_MODEL` (default `gpt-6-luna`) with low effort and strict noun JSON, no stored model responses. Shares the existing translation daily quotas and metadata table; no migration. No corpus, transcript or user text is stored by this function. App cloud consent is required. A new round generates ten records once; article taps use those records locally.

## Live voice with Gemini (`gemini-live-session`)

The live voice (#309). The maintainer compared it with OpenAI's on the iPhone and chose Gemini, at about a fifth of the cost; the OpenAI voice and the switch are gone from the app.

- `{"scenario": "dentist", "instructions": "<context>", "thinking_pause": "2400", "slower": "true"}` answers `{"token", "expires_at", "model", "voice"}`. The token comes from Google's `v1beta/auth_tokens`: it starts one session within a minute, runs for at most 15 minutes, and is locked (`bidiGenerateContentSetup`) to the model, the voice, the tutor instructions, both transcriptions and the silence before an answer. The app connects to `…BidiGenerateContentConstrained?access_token=<token>` and only names the model.
- `"push_to_talk": "true"` (optional, #424) is for hold to talk: Google's own turn detection is switched off (`automaticActivityDetection.disabled`), and the app sends `realtimeInput.activityStart` when the learner presses the orb and `activityEnd` when they let go, with the microphone only in between. Without it, Google answers after `thinking_pause` of silence (hands-free).
- Secrets: `GEMINI_API_KEY` (required; from Google AI Studio, on a project with billing, so nothing is used to improve Google's products), `GEMINI_LIVE_MODEL` (default `gemini-3.8-live`), `GEMINI_LIVE_VOICE` (default `Kore`).
- Limits: the table `realtime_sessions` (named after the old OpenAI voice), with `REALTIME_PER_USER_DAILY` and `REALTIME_GLOBAL_DAILY`.
- Price (Google's pricing page, 14 Nov 2026): $0.005 a minute listened to and $0.018 a minute spoken; OpenAI's `gpt-realtime` is $32 / $64 per million audio tokens.
- Checked from a Mac with the function's own token: a German role-play answered in about two seconds, 24 kHz speech was heard and transcribed, the thinking pause was kept, and talking over the answer was signalled.

## Checks (#439)

The `Server` workflow (`.github/workflows/server.yml`) runs on GitHub's Linux machines for every PR that touches `supabase/`: `deno check`, `deno lint` and `deno test` on the functions, and the migrations and SQL tests on a fresh Postgres 17. Locally:

```sh
cd supabase/functions && deno check */index.ts tests/*.ts && deno lint && deno test --allow-env tests/
PGHOST=localhost PGUSER=postgres ALLTAG_SQL_TEST_DB=1 supabase/tests/run_sql_tests.sh   # a throwaway Postgres only
```

A green workflow doesn't change the live project: after the merge, apply the migration and deploy the functions (see AGENTS.md, Workflow 6).
