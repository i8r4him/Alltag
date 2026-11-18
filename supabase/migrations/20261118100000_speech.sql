-- One row per new sentence spoken with Gemini TTS (`speak`), for daily limits.
-- Only who and when: the text itself is never stored here.
-- RLS is on with no policies: only the Edge Function (service role) reads and writes.
create table public.speech_requests (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

create index speech_requests_user_created on public.speech_requests (user_id, created_at desc);
create index speech_requests_created on public.speech_requests (created_at desc);

alter table public.speech_requests enable row level security;

-- The shared cache of spoken sentences, named by a hash of model, voice and text.
-- Private: no policies, so only the function (service role) reads and writes it.
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('speech', 'speech', false, 2097152, array['audio/wav'])
on conflict (id) do nothing;
