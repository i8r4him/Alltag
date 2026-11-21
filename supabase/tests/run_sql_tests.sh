#!/usr/bin/env bash
# Applies the migrations to an empty Postgres and runs the SQL tests (#439).
# Needs psql and a database the caller may drop and create objects in, given by the usual
# PG* environment variables (CI starts a Postgres service; locally: PGHOST=localhost PGUSER=postgres).
set -euo pipefail
cd "$(dirname "$0")/.."

# It drops and recreates the public schema, so it refuses to run without this switch.
if [ "${ALLTAG_SQL_TEST_DB:-}" != "1" ]; then
  echo "Set ALLTAG_SQL_TEST_DB=1 to confirm the database is a throwaway one." >&2
  exit 1
fi

psql_q() { psql -v ON_ERROR_STOP=1 -q -X "$@"; }

psql_q -c "drop schema if exists public cascade; drop schema if exists auth cascade; create schema public;"
psql_q -c "do \$\$ begin
  if not exists (select from pg_roles where rolname = 'anon') then
    create role anon nologin; create role authenticated nologin; create role service_role nologin;
  end if; end \$\$;"
psql_q -f tests/setup.sql
for migration in migrations/*.sql; do
  psql_q -f "$migration"
done
psql_q -f tests/claim_quota_test.sql

# Two requests at the same moment, with an allowance of one. Request A claims inside a transaction
# that stays open; request B must wait for it (not count past it), and once A is committed B is refused.
user=00000000-0000-0000-0000-000000000001
claim="select status from public.claim_quota('german_checks', '$user', 1, 100)"
fifo=$(mktemp -u)
mkfifo "$fifo"
psql -X -q -v ON_ERROR_STOP=1 < "$fifo" > /dev/null &
holder=$!
exec 3> "$fifo"
echo "begin; $claim;" >&3
# Wait until A holds the table's lock (no sleeps: poll until it shows).
for _ in $(seq 100); do
  held=$(psql -X -t -A -c "select count(*) from pg_locks where locktype = 'advisory' and granted")
  [ "$held" = "1" ] && break
  psql -X -q -c "select pg_sleep(0.05)" > /dev/null
done
[ "$held" = "1" ] || { echo "Request A never took the lock" >&2; exit 1; }
waited=$(psql -X -t -A -c "set lock_timeout = '500ms'; $claim" 2>&1 || true)
if [[ "$waited" != *"lock timeout"* ]]; then
  echo "Request B was not held back while A was claiming: $waited" >&2
  exit 1
fi
echo "commit;" >&3
exec 3>&-
wait "$holder"
rm -f "$fifo"
second=$(psql -X -t -A -c "$claim")
if [ "$second" != "daily_limit" ]; then
  echo "Request B after A: expected daily_limit, got $second" >&2
  exit 1
fi
echo "SQL tests passed"
