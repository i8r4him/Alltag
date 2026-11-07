-- One row per Realtime client secret handed out, for daily limits.
-- RLS is on with no policies: only the Edge Function (service role) reads and writes.
create table public.realtime_sessions (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  scenario text,
  created_at timestamptz not null default now()
);

create index realtime_sessions_user_created on public.realtime_sessions (user_id, created_at desc);
create index realtime_sessions_created on public.realtime_sessions (created_at desc);

alter table public.realtime_sessions enable row level security;
