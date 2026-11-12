-- One row per sentence checked with OpenAI, for daily limits.
-- Only who and when: the sentence itself is never stored.
-- RLS is on with no policies: only the Edge Function (service role) reads and writes.
create table public.german_checks (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

create index german_checks_user_created on public.german_checks (user_id, created_at desc);
create index german_checks_created on public.german_checks (created_at desc);

alter table public.german_checks enable row level security;
