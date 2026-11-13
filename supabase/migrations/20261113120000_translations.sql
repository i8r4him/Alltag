-- One row per text translated with OpenAI, for daily limits.
-- Only who and when: the text itself is never stored.
-- RLS is on with no policies: only the Edge Function (service role) reads and writes.
create table public.translations (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

create index translations_user_created on public.translations (user_id, created_at desc);
create index translations_created on public.translations (created_at desc);

alter table public.translations enable row level security;
