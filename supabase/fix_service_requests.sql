-- Create service_requests + policies (safe to re-run)
-- Run in Supabase SQL Editor, then try Service Requests again.

create table if not exists service_requests (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  hostel_id uuid references hostels (id) on delete set null,
  category text not null,
  title text not null,
  description text not null default '',
  status text not null default 'Open',
  created_at timestamptz default now()
);

create index if not exists idx_service_requests_user_id on service_requests (user_id);
create index if not exists idx_service_requests_hostel_id on service_requests (hostel_id);
create index if not exists idx_service_requests_created_at on service_requests (created_at desc);

alter table service_requests enable row level security;

-- Helpers (keep existing definitions if already present)
create or replace function public.is_super_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select role from profiles where id = auth.uid()),
    'resident'
  ) = 'super_admin';
$$;

create or replace function public.manages_hostel(target_hostel_id uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select
    public.is_super_admin()
    or (
      coalesce((select role from profiles where id = auth.uid()), 'resident') = 'admin'
      and (select hostel_id from profiles where id = auth.uid()) = target_hostel_id
    );
$$;

drop policy if exists "Users insert own service requests" on service_requests;
drop policy if exists "Users read service requests" on service_requests;
drop policy if exists "Users update service requests" on service_requests;
drop policy if exists "Users read own service requests" on service_requests;
drop policy if exists "Users update own service requests" on service_requests;

create policy "Users insert own service requests"
  on service_requests for insert to authenticated
  with check (auth.uid() = user_id);

create policy "Users read service requests"
  on service_requests for select to authenticated
  using (
    auth.uid() = user_id
    or public.is_super_admin()
    or (hostel_id is not null and public.manages_hostel(hostel_id))
  );

create policy "Users update service requests"
  on service_requests for update to authenticated
  using (
    auth.uid() = user_id
    or public.is_super_admin()
    or (hostel_id is not null and public.manages_hostel(hostel_id))
  )
  with check (
    auth.uid() = user_id
    or public.is_super_admin()
    or (hostel_id is not null and public.manages_hostel(hostel_id))
  );

notify pgrst, 'reload schema';
