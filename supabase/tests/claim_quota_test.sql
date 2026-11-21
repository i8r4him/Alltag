-- Tests for claim_quota and release_quota (#439). Run by run_sql_tests.sh on a plain Postgres.
\set ON_ERROR_STOP on

insert into auth.users (id) values
  ('00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000002'),
  ('00000000-0000-0000-0000-00000000000d');
insert into public.realtime_developers (user_id, note) values ('00000000-0000-0000-0000-00000000000d', 'test');

do $$
declare
  r record;
  first_id bigint;
begin
  -- Under the limit: claimed, with a row.
  select * into r from public.claim_quota('german_checks', '00000000-0000-0000-0000-000000000001', 2, 10);
  assert r.status = 'ok' and r.claim_id is not null and not r.is_developer, format('first claim: %s', r);
  first_id := r.claim_id;
  select * into r from public.claim_quota('german_checks', '00000000-0000-0000-0000-000000000001', 2, 10);
  assert r.status = 'ok', format('second claim: %s', r);

  -- At the per-user limit: refused, and nothing inserted.
  select * into r from public.claim_quota('german_checks', '00000000-0000-0000-0000-000000000001', 2, 10);
  assert r.status = 'daily_limit' and r.claim_id is null, format('third claim: %s', r);
  assert (select count(*) from public.german_checks) = 2, 'a refused claim inserted a row';

  -- Another learner still has their own allowance.
  select * into r from public.claim_quota('german_checks', '00000000-0000-0000-0000-000000000002', 2, 10);
  assert r.status = 'ok', format('other learner: %s', r);

  -- Giving a claim back frees the allowance.
  perform public.release_quota('german_checks', first_id, '00000000-0000-0000-0000-000000000001');
  select * into r from public.claim_quota('german_checks', '00000000-0000-0000-0000-000000000001', 2, 10);
  assert r.status = 'ok', format('after release: %s', r);

  -- Releasing someone else's claim does nothing.
  perform public.release_quota('german_checks', r.claim_id, '00000000-0000-0000-0000-000000000002');
  assert exists (select 1 from public.german_checks where id = r.claim_id), 'released another learner''s claim';

  -- Rows older than 24 hours don't count.
  update public.german_checks set created_at = now() - interval '25 hours'
    where user_id = '00000000-0000-0000-0000-000000000001';
  select * into r from public.claim_quota('german_checks', '00000000-0000-0000-0000-000000000001', 2, 10);
  assert r.status = 'ok', format('after a day: %s', r);

  -- Developers skip the per-user limit but not the global one.
  select * into r from public.claim_quota('translations', '00000000-0000-0000-0000-00000000000d', 0, 1);
  assert r.status = 'ok' and r.is_developer, format('developer: %s', r);
  select * into r from public.claim_quota('translations', '00000000-0000-0000-0000-00000000000d', 0, 1);
  assert r.status = 'busy', format('developer at the global limit: %s', r);

  -- The global limit holds for everyone.
  select * into r from public.claim_quota('translations', '00000000-0000-0000-0000-000000000002', 5, 1);
  assert r.status = 'busy', format('global limit: %s', r);

  -- Live sessions keep their scenario, cut to 64 characters.
  select * into r from public.claim_quota('realtime_sessions', '00000000-0000-0000-0000-000000000002', 5, 5, repeat('x', 100));
  assert r.status = 'ok', format('session: %s', r);
  assert (select length(scenario) from public.realtime_sessions where id = r.claim_id) = 64, 'scenario not cut';
end;
$$;

-- Only known tables.
do $$
begin
  perform public.claim_quota('realtime_developers', '00000000-0000-0000-0000-000000000001', 5, 5);
  raise exception 'claimed on an unknown table';
exception when raise_exception then
  if sqlerrm = 'claimed on an unknown table' then raise; end if;
end;
$$;

-- The app's roles can't call them.
do $$
begin
  assert not has_function_privilege('anon', 'public.claim_quota(text, uuid, integer, integer, text)', 'execute'),
    'anon may claim';
  assert not has_function_privilege('authenticated', 'public.claim_quota(text, uuid, integer, integer, text)', 'execute'),
    'authenticated may claim';
  assert not has_function_privilege('authenticated', 'public.release_quota(text, bigint, uuid)', 'execute'),
    'authenticated may release';
  assert has_function_privilege('service_role', 'public.claim_quota(text, uuid, integer, integer, text)', 'execute'),
    'service_role may not claim';
end;
$$;

-- Clean up for the parallel test that follows.
truncate public.german_checks, public.translations, public.realtime_sessions;
