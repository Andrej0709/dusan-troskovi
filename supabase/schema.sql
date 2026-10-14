-- Troškovi: Supabase schema.
-- Run once in Supabase: SQL Editor -> New query -> paste -> Run. Safe to run again.
--
-- There is no login: the anon key in config.js can read and write everything.
-- Anyone who has the site URL can see and change the data.

create table if not exists public.expenses (
  id          text primary key,
  title       text not null default '',
  amount      numeric(12, 2) not null check (amount >= 0),
  date        date not null,
  category    text not null default '',
  method      text not null default '',
  note        text not null default '',
  sub_id      text,
  example     boolean not null default false,
  created_at  bigint not null default (extract(epoch from now()) * 1000)::bigint
);
create index if not exists expenses_date_idx on public.expenses (date desc);

create table if not exists public.subs (
  id          text primary key,
  name        text not null,
  amount      numeric(12, 2) not null check (amount >= 0),
  cycle       text not null default 'mesecno' check (cycle in ('nedeljno', 'mesecno', 'godisnje')),
  next_date   date,
  category    text not null default '',
  method      text not null default '',
  active      boolean not null default true,
  example     boolean not null default false,
  created_at  bigint not null default (extract(epoch from now()) * 1000)::bigint
);

-- One row (id = 'main') holding categories, payment methods and currency.
create table if not exists public.config (
  id    text primary key,
  data  jsonb not null default '{}'::jsonb
);

-- Row level security with open policies for the anon role (no login).
alter table public.expenses enable row level security;
alter table public.subs     enable row level security;
alter table public.config   enable row level security;

drop policy if exists "anon full access" on public.expenses;
drop policy if exists "anon full access" on public.subs;
drop policy if exists "anon full access" on public.config;
create policy "anon full access" on public.expenses for all to anon using (true) with check (true);
create policy "anon full access" on public.subs     for all to anon using (true) with check (true);
create policy "anon full access" on public.config   for all to anon using (true) with check (true);

grant select, insert, update, delete on public.expenses, public.subs, public.config to anon;

-- Realtime, so a change on one device shows up on the others right away.
do $$ begin alter publication supabase_realtime add table public.expenses; exception when duplicate_object then null; end $$;
do $$ begin alter publication supabase_realtime add table public.subs;     exception when duplicate_object then null; end $$;
do $$ begin alter publication supabase_realtime add table public.config;   exception when duplicate_object then null; end $$;
