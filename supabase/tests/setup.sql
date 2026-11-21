-- What Supabase provides and the migrations expect. Only for the SQL tests on a plain Postgres;
-- never applied to the project. The roles anon, authenticated and service_role are made by the runner.
create schema auth;
create table auth.users (id uuid primary key);
