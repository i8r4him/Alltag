# Alltag backend (Supabase)

The project is `Alltag` (ref `flbymqlcauvwumznvviq`, region eu-central-1, free plan).
Its only job is to keep the OpenAI API key off the phone.

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

## Files

- `functions/realtime-session/index.ts`: the function. Deploy it with JWT verification on.
- `migrations/20261107200000_realtime_sessions.sql`: the session log used for the limits.
- `migrations/20261111100000_realtime_developers.sql`: the accounts that skip the per-user limit.
