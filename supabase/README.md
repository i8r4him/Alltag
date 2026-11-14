# Alltag backend (Supabase)

The project is `Alltag` (ref `flbymqlcauvwumznvviq`, region eu-central-1, free plan).
Its only job is to keep the OpenAI API key off the phone: for the live voice, for checking sentences, and for translating.

```
App ──(Supabase anonymous session)──▶ realtime-session ──(OPENAI_API_KEY)──▶ OpenAI
App ◀── short-lived client secret (60 s to connect) ──┘
App ──(client secret)──▶ OpenAI Realtime API (audio both ways)
```

## Public values (fine to ship in the app)

| | |
|---|---|
| URL | `https://flbymqlcauvwumznvviq.supabase.co` |
| Publishable key | `sb_publishable_b26lEqjEmiwWbQYZ-EO4QQ_d5OB-mUV` |

## The app's side

1. **Sign in anonymously once.** Send `POST {URL}/auth/v1/signup` with the headers `apikey: <publishable key>` and `Content-Type: application/json`, and the body `{}`.
   - It returns `access_token`, `refresh_token` and `expires_in`. Keep them in the Keychain.
   - To refresh, send `POST {URL}/auth/v1/token?grant_type=refresh_token` with `{"refresh_token": "…"}` and the same `apikey` header.
2. **Ask for a client secret** for each conversation.
   - Send `POST {URL}/functions/v1/realtime-session` with the headers `Authorization: Bearer <access_token>` and `apikey: <publishable key>`.
   - The body is `{"scenario": "dentist", "instructions": "<scenario, goal, learner level>"}`. Both fields are optional, and `instructions` is limited to 4,000 characters.
   - `200` returns `{"client_secret": "ek_…", "expires_at": <unix seconds>, "model": "…", "voice": "…"}`.
   - The errors are listed in the next table.
3. **Connect to the OpenAI Realtime API** with `client_secret` before it expires. Check the endpoint and event names against OpenAI's current Realtime docs.

| Status | `error` | Meaning |
|---|---|---|
| 401 | `unauthorized` | No or expired Supabase token. Refresh it and retry once. |
| 429 | `daily_limit` | This learner used today's sessions (`REALTIME_PER_USER_DAILY`, default 10). Developer accounts are exempt (see below). |
| 429 | `busy` | Everyone together reached `REALTIME_GLOBAL_DAILY` (default 200). |
| 502 | `upstream` | OpenAI refused. Check the function logs. |
| 503 | `not_configured` / `unavailable` | No `OPENAI_API_KEY` set, or the database is unreachable. |

## Secrets (set by the maintainer, never committed)

Set them in the dashboard (Edge Functions → Secrets) or with the CLI:

```sh
supabase secrets set --project-ref flbymqlcauvwumznvviq OPENAI_API_KEY=sk-…
# optional
supabase secrets set --project-ref flbymqlcauvwumznvviq REALTIME_MODEL=gpt-realtime REALTIME_VOICE=marin \
  REALTIME_PER_USER_DAILY=10 REALTIME_GLOBAL_DAILY=200
```

Required dashboard setting: under **Authentication → Sign In / Providers**, turn on **Allow anonymous sign-ins**.

## Limits and cost

- A client secret is only valid for connecting. Once connected, a Realtime session runs until the app closes it.
  - Close sessions in the app when the conversation ends, and after about 10 minutes at most.
  - The daily counts cap how many sessions can start.
- Anonymous accounts are free to create, so the global cap is the real ceiling on the bill.
  - Before a public release, add App Attest (needs the paid developer account) or a captcha on sign-in.
  - Set a monthly budget limit in the OpenAI dashboard.
- The table `realtime_sessions` has RLS on and no policies, so only the function (service role) can read or write it.

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
- `200` returns `{"german", "other", "source_is_german", "note", "words": [{word, grammar, meaning}], "tones": [{tone, german}], "examples": [{german, other}]}`.
- **Nothing the learner wrote is stored.** The table `translations` keeps only who asked and when, for the limits: `TRANSLATE_PER_USER_DAILY` (default 200) and `TRANSLATE_GLOBAL_DAILY` (default 20,000). Developer accounts skip the per-user limit.
- Set `stream` to the string `"true"` to receive OpenAI server-sent events as the answer is generated; without it, the function retains its JSON response for older app versions. Streaming requests count towards the quota when OpenAI accepts them.
- The model is `TRANSLATE_MODEL` (default `gpt-6-luna`), asked for **low reasoning effort**: about 3 seconds an answer instead of 5 to 10. Sent with `store: false`.
- It needs the same Responses permission on the OpenAI key as `check-german`.

## Files

- `functions/realtime-session/index.ts`: the voice function. Deploy it with JWT verification on.
- `functions/check-german/index.ts`: the sentence check. Deploy it with JWT verification on.
- `functions/translate/index.ts`: translating. Deploy it with JWT verification on.
- `functions/write/index.ts`: Learn › Write's tasks and corrections. Deploy it with JWT verification on.
- `migrations/20261107200000_realtime_sessions.sql`: the session log used for the limits.
- `migrations/20261111100000_realtime_developers.sql`: the accounts that skip the per-user limit.
- `migrations/20261113100000_german_checks.sql`: the check log used for the limits.
- `migrations/20261113120000_translations.sql`: the translation log used for the limits.

## Articles (`articles`)

Authenticated OpenAI noun lookup (`action: lookup`, `text`) and random practice batches (`action: practice`, `level`, optional recent `exclude` words). Uses `ARTICLES_MODEL` (default `gpt-6-luna`) with low effort and strict noun JSON, no stored model responses. Shares the existing translation daily quotas and metadata table; no migration. No corpus, transcript or user text is stored by this function. App cloud consent is required. A new round generates ten records once; article taps use those records locally.

## Writing (`write`)

Learn › Write. Two actions, both with strict JSON and `store: false`; nothing the learner wrote is stored.

- `{"action": "task", "level": "B1", "length": "quick", "kind": "email", "exclude": "<recent titles>"}` writes a new everyday task for the level: title, situation, recipient, register, kind, the points, the word range, an SF Symbol and three or four phrases. `length` is `quick`, `standard` (the default) or `exam`; the function sets the word range from its own table (the same as the app's `WritingLength`) and the number of points (two for quick, three otherwise). `kind` is `message`, `email`, `complaint` or `day` (a personal text with no recipient); without it the model chooses. It counts against the translation quota (`translations`).
- `{"action": "check", "level": "B1", "task": "<the task>", "text": "<the learner's text>", "stream": "true"}` marks the text sentence by sentence (fix, note or good, with the correction), plus the corrected text, whether each point was covered and a short summary. Without `task` it is free writing (the learner's own topic): the German alone is marked and `points` is empty. It counts against the sentence-check quota (`german_checks`). With `stream`, OpenAI's events are forwarded so the app shows each sentence as it is done.
- Models: `WRITE_TASK_MODEL` / `WRITE_TASK_EFFORT` (default `gpt-6-luna`, low) and `WRITE_CHECK_MODEL` / `WRITE_CHECK_EFFORT` (default `gpt-6.1-terra`, low), chosen by the measurement below. Accounts in `realtime_developers` may pass `model` (`gpt-6-luna`, `gpt-6.1-terra`, `gpt-6.1-sol`) and `effort` to compare; the OpenAI project must allow that model.
- Every non-streamed answer carries `usage` (model, effort, input, output and reasoning tokens), to compare cost.
- No migration.

### Which model (measured 14 Nov 2026)

Prices from OpenAI's pricing page: Luna $0.10 in / $0.50 out per million tokens, Terra $1 / $5; thinking is billed as output. Checks: four learner texts with planted mistakes (A2 with 5, B1 with 4, C1 with 5 subtle ones, and a B2 text with none, to count false fixes), each checked twice per setting, streamed. Tasks: one each for A1, B1 and C1 per setting.

| Check (per call, 4 texts × 2 runs) | Mistakes found (of 28) | False fixes | First sentence | Total | Output tokens | Price | 1,000 checks |
|---|---|---|---|---|---|---|---|
| Luna, low | 26 | 3 | 5.4 s | 12 s | 1,350 | $0.0008 | $0.76 |
| Luna, medium | 27 | 4 | 17 s | 25 s | 2,386 | $0.0013 | $1.28 |
| Luna, high | 28 | 2 | 24 s | 31 s | 3,402 | $0.0018 | $1.79 |
| Terra, none | 26 | 1 | 2.1 s | 12 s | 925 | $0.0055 | $5.52 |
| **Terra, low** | **28** | **1** | **3.1 s** | **13 s** | 1,016 | **$0.0060** | **$5.97** |
| Terra, medium | 28 | 1 | 5.7 s | 15 s | 1,252 | $0.0072 | $7.15 |

| Task (per call, A1 · B1 · C1) | Time | Output tokens | Price |
|---|---|---|---|
| **Luna, low** | **4.4 s** | 268 | **$0.0002** |
| Luna, medium | 10 s | 579 | $0.0004 |
| Luna, high | 10 s | 779 | $0.0005 |
| Terra, none | 4.4 s | 221 | $0.0022 |
| Terra, low | 4.5 s | 248 | $0.0023 |
| Terra, medium | 5.5 s | 356 | $0.0029 |

- **Checks: Terra at low effort.** It found every planted mistake, like Luna at high, but shows the first sentence after 3 s instead of 24 s and marks the fewest correct sentences as wrong. It costs 3.3 times Luna at high. Luna at low missed the misspelt word both times.
- **Luna's false fixes** were about facts, not German: it "corrected" „mehr als 120 Minuten" because the task said two hours. Terra's one false fix was a defensible word choice („den Rest des Treffens erreichen").
- **Tasks: Luna at low effort.** Every task was at the level, concrete and in correct German with all six settings; Luna at low is the fastest and a tenth of Terra's price.
- **Per learner:** someone who checks 30 texts and asks for 15 new tasks a month costs about $0.18 (Luna at high: $0.06).
- Luna sometimes changes the line breaks in `corrected`; the app lays the corrections over the learner's own text, so it isn't affected.
