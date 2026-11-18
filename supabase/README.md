# Alltag backend (Supabase)

The project is `Alltag` (ref `flbymqlcauvwumznvviq`, region eu-central-1, free plan).
Its only job is to keep the API keys off the phone: Google's for the live voice and the spoken sentences, OpenAI's for checking sentences, translating and articles.

```
App ──(Supabase anonymous session)──▶ gemini-live-session ──(GEMINI_API_KEY)──▶ Google
App ◀── short-lived token (one session, within a minute) ──┘
App ──(token)──▶ Gemini Live API (audio both ways)
```

The live voice is Gemini only (#309). The old OpenAI voice function, `realtime-session`, is still deployed but the app no longer calls it; retiring it waits for the maintainer.

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

## Files

- `functions/gemini-live-session/index.ts`: the live voice (Google's Gemini Live). Deploy it with JWT verification on.
- `functions/realtime-session/index.ts`: the old OpenAI voice. Deployed, unused by the app.
- `functions/check-german/index.ts`: the sentence check. Deploy it with JWT verification on.
- `functions/translate/index.ts`: translating. Deploy it with JWT verification on.
- `functions/speak/index.ts`: the natural voice of every Listen button. Deploy it with JWT verification on.
- `functions/speak-warm/index.ts`: makes the voice of the app's fixed German ahead of time, for `scripts/warm_speech.py`. Deployed **without** JWT verification: it checks its own token instead.
- `migrations/20261107200000_realtime_sessions.sql`: the session log used for the limits.
- `migrations/20261111100000_realtime_developers.sql`: the accounts that skip the per-user limit.
- `migrations/20261113100000_german_checks.sql`: the check log used for the limits.
- `migrations/20261113120000_translations.sql`: the translation log used for the limits.
- `migrations/20261118100000_speech.sql`: the log of new spoken sentences used for the limits, and the private Storage bucket `speech` that caches the audio.

## Articles (`articles`)

Authenticated OpenAI noun lookup (`action: lookup`, `text`) and random practice batches (`action: practice`, `level`, optional recent `exclude` words). Uses `ARTICLES_MODEL` (default `gpt-6-luna`) with low effort and strict noun JSON, no stored model responses. Shares the existing translation daily quotas and metadata table; no migration. No corpus, transcript or user text is stored by this function. App cloud consent is required. A new round generates ten records once; article taps use those records locally.

## Live voice with Gemini (`gemini-live-session`)

The live voice (#309). The maintainer compared it with OpenAI's on the iPhone and chose Gemini, at about a fifth of the cost; the OpenAI voice and the switch are gone from the app.

- `{"scenario": "dentist", "instructions": "<context>", "thinking_pause": "2400", "slower": "true"}` answers `{"token", "expires_at", "model", "voice"}`. The token comes from Google's `v1beta/auth_tokens`: it starts one session within a minute, runs for at most 15 minutes, and is locked (`bidiGenerateContentSetup`) to the model, the voice, the tutor instructions, both transcriptions and the silence before an answer. The app connects to `…BidiGenerateContentConstrained?access_token=<token>` and only names the model.
- Secrets: `GEMINI_API_KEY` (required; from Google AI Studio, on a project with billing, so nothing is used to improve Google's products), `GEMINI_LIVE_MODEL` (default `gemini-3.8-live`), `GEMINI_LIVE_VOICE` (default `Kore`).
- Limits: the same table and the same numbers as `realtime-session` (`REALTIME_PER_USER_DAILY`, `REALTIME_GLOBAL_DAILY`), so a learner has one allowance for the live voice. No migration.
- Price (Google's pricing page, 14 Nov 2026): $0.005 a minute listened to and $0.018 a minute spoken; OpenAI's `gpt-realtime` is $32 / $64 per million audio tokens.
- Checked from a Mac with the function's own token: a German role-play answered in about two seconds, 24 kHz speech was heard and transcribed, the thinking pause was kept, and talking over the answer was signalled.

## Speaking German (`speak`)

Every Listen button in the app (#422): a natural voice in place of the iPhone's.

- Send `POST {URL}/functions/v1/speak` with the same two headers as above and `{"text": "…"}` (300 characters at most; the app sends one sentence at a time).
- `200` returns the audio itself, `audio/wav` (24 kHz, mono, 16-bit), with the header `X-Alltag-Cache: hit` or `miss`.
- **One sentence is made once, for everyone.** The audio is kept in the private Storage bucket `speech`, named by a SHA-256 of the model, the voice, the reading style and the text. A sentence someone asked for before comes from there and costs nothing but the download. The app keeps what it played too, so a replay doesn't even ask.
- **Only new sentences count** towards the limits, in the table `speech_requests` (who and when, never the text): `SPEAK_PER_USER_DAILY` (default 300) and `SPEAK_GLOBAL_DAILY` (default 20,000). Developer accounts skip the per-user limit. The errors are the same as in the table above, plus `400 bad_request` for an empty or too long text.
- The model is `SPEAK_MODEL` (default `gemini-3.8-flash-lite-tts`) with the voice `SPEAK_VOICE` (default `Kore`).
- **Its own key, so its cost shows on its own:** `SPEAK_GEMINI_API_KEY`, from a separate Google AI Studio project with billing (Google bills per project). Without it the function falls back to the live voice's `GEMINI_API_KEY`. Changing either makes new cache entries; the old ones stay until deleted in Storage. The function asks Google's Interactions API and, if that refuses, `generateContent`.
- **Cost:** about $0.009 a minute of speech now and $0.018 from 1 Jan 2027 (Google doubles the TTS prices then), paid only once per sentence. The audio is uncompressed WAV (about 48 KB a second), so Storage and egress grow with use: watch them on the free plan (5 GB egress a month).
- The cached audio is of the text only, with no link to who asked. Translate's German answers end up there too: say so in the privacy policy.
- **Made ahead of time:** a new sentence takes Gemini about four seconds, so the fixed German (each word collection's example and word, each grammar rule's sentence) is made once in advance by `scripts/warm_speech.py` through `speak-warm`, which makes only what the cache lacks. Run it again after adding content. `speak-warm` takes a token in `X-Warm-Token` whose SHA-256 is in its code; the token itself is in no repo (the script reads `.warm_token`, ignored by git). For a new run, make a new token, put its hash in the function and deploy it.
