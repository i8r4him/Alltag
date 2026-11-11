-- Accounts that skip the per-user daily limit, for development and testing.
-- The global limit still applies to them, as the ceiling on the OpenAI bill.
-- RLS is on with no policies: only the Edge Function (service role) reads it.
-- Rows are added by the maintainer in the SQL editor, never by the app.
create table public.realtime_developers (
  user_id uuid primary key references auth.users (id) on delete cascade,
  note text,
  created_at timestamptz not null default now()
);

alter table public.realtime_developers enable row level security;
