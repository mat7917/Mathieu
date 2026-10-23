create extension if not exists pgcrypto;
create or replace function public.set_updated_at() returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end; $$;

create table if not exists public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.missions (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id) on delete cascade,
 title text not null check(char_length(title) between 3 and 180),
 objective text not null check(char_length(objective) between 8 and 10000),
 status text not null default 'draft' check(status in ('draft','queued','running','blocked','completed','cancelled')),
 is_simulation boolean not null default false,
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create index if not exists missions_owner_created_idx on public.missions(owner_id,created_at desc);
create table if not exists public.tasks (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id) on delete cascade,
 mission_id uuid references public.missions(id) on delete set null,
 title text not null check(char_length(title) between 1 and 240),
 status text not null default 'queued' check(status in ('queued','running','blocked','completed','failed','cancelled')),
 payload jsonb not null default '{}'::jsonb, result jsonb,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.events (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null references auth.users(id) on delete cascade,
 mission_id uuid references public.missions(id) on delete set null,
 event_type text not null check(char_length(event_type) between 1 and 100),
 details jsonb not null default '{}'::jsonb, created_at timestamptz not null default now()
);
create table if not exists public.discoveries (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 title text not null, summary text not null default '', source_url text, source_label text,
 confidence numeric(4,3) check(confidence between 0 and 1),
 status text not null default 'unreviewed' check(status in ('unreviewed','accepted','rejected','duplicate')),
 created_at timestamptz not null default now()
);
create table if not exists public.hypotheses (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 discovery_id uuid references public.discoveries(id) on delete set null,
 statement text not null, falsification_criteria text not null default '',
 status text not null default 'proposed' check(status in ('proposed','testing','supported','refuted','inconclusive')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.experiments (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 hypothesis_id uuid references public.hypotheses(id) on delete set null,
 protocol jsonb not null default '{}'::jsonb, outcome jsonb,
 status text not null default 'planned' check(status in ('planned','running','completed','failed','cancelled')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.evidence (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 mission_id uuid references public.missions(id) on delete set null,
 experiment_id uuid references public.experiments(id) on delete set null,
 title text not null, source_url text, content_hash text,
 verification_status text not null default 'unverified' check(verification_status in ('unverified','verified','rejected')),
 notes text not null default '', created_at timestamptz not null default now()
);
create table if not exists public.memories (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 title text not null, content text not null, source_ref text,
 confidence numeric(4,3) check(confidence between 0 and 1),
 validation_status text not null default 'pending' check(validation_status in ('pending','validated','rejected')),
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table if not exists public.permissions (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 scope text not null, permission text not null check(permission in ('read','write','execute','deploy')),
 granted boolean not null default false, expires_at timestamptz, created_at timestamptz not null default now()
);
create table if not exists public.approvals (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 action_type text not null, description text not null,
 risk_level text not null default 'medium' check(risk_level in ('low','medium','high','critical')),
 status text not null default 'pending' check(status in ('pending','approved','rejected','expired')),
 decided_at timestamptz, created_at timestamptz not null default now()
);
create table if not exists public.module_versions (
 id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade,
 module_key text not null, version text not null,
 status text not null default 'proposed' check(status in ('proposed','approved','active','rolled_back')),
 changelog text not null default '', created_at timestamptz not null default now(),
 unique(owner_id,module_key,version)
);

alter table public.profiles enable row level security;
alter table public.missions enable row level security;
alter table public.tasks enable row level security;
alter table public.events enable row level security;
alter table public.discoveries enable row level security;
alter table public.hypotheses enable row level security;
alter table public.experiments enable row level security;
alter table public.evidence enable row level security;
alter table public.memories enable row level security;
alter table public.permissions enable row level security;
alter table public.approvals enable row level security;
alter table public.module_versions enable row level security;

create policy profiles_select_own on public.profiles for select to authenticated using(id=(select auth.uid()));
create policy profiles_insert_own on public.profiles for insert to authenticated with check(id=(select auth.uid()));
create policy profiles_update_own on public.profiles for update to authenticated using(id=(select auth.uid())) with check(id=(select auth.uid()));

create policy missions_select_own on public.missions for select to authenticated using(owner_id=(select auth.uid()));
create policy missions_insert_own on public.missions for insert to authenticated with check(owner_id=(select auth.uid()));
create policy missions_update_own on public.missions for update to authenticated using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
create policy missions_delete_own on public.missions for delete to authenticated using(owner_id=(select auth.uid()));

create policy tasks_select_own on public.tasks for select to authenticated using(owner_id=(select auth.uid()));
create policy tasks_insert_own on public.tasks for insert to authenticated with check(owner_id=(select auth.uid()));
create policy tasks_update_own on public.tasks for update to authenticated using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
create policy tasks_delete_own on public.tasks for delete to authenticated using(owner_id=(select auth.uid()));

create policy events_select_own on public.events for select to authenticated using(owner_id=(select auth.uid()));
create policy discoveries_select_own on public.discoveries for select to authenticated using(owner_id=(select auth.uid()));
create policy discoveries_insert_own on public.discoveries for insert to authenticated with check(owner_id=(select auth.uid()));
create policy discoveries_update_own on public.discoveries for update to authenticated using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
create policy discoveries_delete_own on public.discoveries for delete to authenticated using(owner_id=(select auth.uid()));
create policy hypotheses_select_own on public.hypotheses for select to authenticated using(owner_id=(select auth.uid()));
create policy hypotheses_insert_own on public.hypotheses for insert to authenticated with check(owner_id=(select auth.uid()));
create policy hypotheses_update_own on public.hypotheses for update to authenticated using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
create policy hypotheses_delete_own on public.hypotheses for delete to authenticated using(owner_id=(select auth.uid()));
create policy experiments_select_own on public.experiments for select to authenticated using(owner_id=(select auth.uid()));
create policy experiments_insert_own on public.experiments for insert to authenticated with check(owner_id=(select auth.uid()));
create policy experiments_update_own on public.experiments for update to authenticated using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
create policy experiments_delete_own on public.experiments for delete to authenticated using(owner_id=(select auth.uid()));
create policy evidence_select_own on public.evidence for select to authenticated using(owner_id=(select auth.uid()));
create policy evidence_insert_own on public.evidence for insert to authenticated with check(owner_id=(select auth.uid()));
create policy evidence_update_own on public.evidence for update to authenticated using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
create policy evidence_delete_own on public.evidence for delete to authenticated using(owner_id=(select auth.uid()));
create policy memories_select_own on public.memories for select to authenticated using(owner_id=(select auth.uid()));
create policy memories_insert_own on public.memories for insert to authenticated with check(owner_id=(select auth.uid()));
create policy memories_update_own on public.memories for update to authenticated using(owner_id=(select auth.uid())) with check(owner_id=(select auth.uid()));
create policy memories_delete_own on public.memories for delete to authenticated using(owner_id=(select auth.uid()));
create policy permissions_select_own on public.permissions for select to authenticated using(owner_id=(select auth.uid()));
create policy approvals_select_own on public.approvals for select to authenticated using(owner_id=(select auth.uid()));
create policy module_versions_select_own on public.module_versions for select to authenticated using(owner_id=(select auth.uid()));

create trigger profiles_updated_at before update on public.profiles for each row execute function public.set_updated_at();
create trigger missions_updated_at before update on public.missions for each row execute function public.set_updated_at();
create trigger tasks_updated_at before update on public.tasks for each row execute function public.set_updated_at();
create trigger hypotheses_updated_at before update on public.hypotheses for each row execute function public.set_updated_at();
create trigger experiments_updated_at before update on public.experiments for each row execute function public.set_updated_at();
create trigger memories_updated_at before update on public.memories for each row execute function public.set_updated_at();
-- Events, permissions, approvals and module_versions have no client write policy; use audited server functions.
