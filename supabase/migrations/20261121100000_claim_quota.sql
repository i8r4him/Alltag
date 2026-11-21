-- The daily limits, counted and claimed in one step (#439).
--
-- Before, each function counted the rows of the last 24 hours and inserted one after the
-- upstream call: two requests at the same moment could both pass a limit. `claim_quota` takes
-- a lock per table, counts and inserts the claim in one transaction, and `release_quota` gives a
-- claim back when the upstream call fails, so a failed request still doesn't count.
--
-- Only the Edge Functions (service role) may call them; the app can't.

create or replace function public.claim_quota(
  p_table text,
  p_user uuid,
  p_per_user integer,
  p_global integer,
  p_scenario text default null
)
returns table (status text, claim_id bigint, is_developer boolean)
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_since timestamptz := now() - interval '24 hours';
  v_developer boolean;
  v_mine bigint;
  v_everyone bigint;
  v_id bigint;
begin
  if p_table not in ('realtime_sessions', 'german_checks', 'translations') then
    raise exception 'claim_quota: unknown table %', p_table;
  end if;

  -- One claim at a time per table, so the count can't change between counting and inserting.
  perform pg_advisory_xact_lock(hashtext('claim_quota:' || p_table));

  -- Accounts in realtime_developers skip the per-user limit; the global limit still applies.
  v_developer := exists (select 1 from public.realtime_developers d where d.user_id = p_user);

  execute format(
    'select count(*) filter (where user_id = $1), count(*) from public.%I where created_at >= $2',
    p_table
  ) into v_mine, v_everyone using p_user, v_since;

  if not v_developer and v_mine >= p_per_user then
    return query select 'daily_limit'::text, null::bigint, v_developer;
    return;
  end if;
  if v_everyone >= p_global then
    return query select 'busy'::text, null::bigint, v_developer;
    return;
  end if;

  if p_table = 'realtime_sessions' then
    insert into public.realtime_sessions (user_id, scenario)
    values (p_user, left(p_scenario, 64))
    returning id into v_id;
  else
    execute format('insert into public.%I (user_id) values ($1) returning id', p_table)
      into v_id using p_user;
  end if;

  return query select 'ok'::text, v_id, v_developer;
end;
$$;

create or replace function public.release_quota(p_table text, p_claim_id bigint, p_user uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
begin
  if p_table not in ('realtime_sessions', 'german_checks', 'translations') then
    raise exception 'release_quota: unknown table %', p_table;
  end if;
  execute format('delete from public.%I where id = $1 and user_id = $2', p_table)
    using p_claim_id, p_user;
end;
$$;

revoke all on function public.claim_quota(text, uuid, integer, integer, text) from public, anon, authenticated;
revoke all on function public.release_quota(text, bigint, uuid) from public, anon, authenticated;
grant execute on function public.claim_quota(text, uuid, integer, integer, text) to service_role;
grant execute on function public.release_quota(text, bigint, uuid) to service_role;
