-- Run this in the Supabase SQL editor (safe to re-run).

create table if not exists hostels (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text not null,
  city text not null default 'Hyderabad',
  area text not null default 'KPHB',
  created_at timestamptz default now()
);

create table if not exists sharing_types (
  id uuid primary key default gen_random_uuid(),
  label text not null unique,
  amount numeric not null,
  sort_order int not null default 0
);

create table if not exists profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  first_name text not null,
  last_name text not null,
  email text not null,
  phone text not null,
  job_title text,
  hostel_id uuid references hostels (id),
  sharing_type_id uuid references sharing_types (id),
  payment_date text not null,
  amount numeric not null default 0,
  sharing_label text not null default '',
  hostel_name text not null default '',
  hostel_address text not null default '',
  is_admin boolean not null default false,
  created_at timestamptz default now()
);

create table if not exists food_menus (
  id uuid primary key default gen_random_uuid(),
  hostel_id uuid references hostels (id) on delete cascade,
  city text not null default 'Hyderabad',
  area text not null default 'KPHB',
  hostel_name text not null,
  menu_data jsonb not null default '{}'::jsonb,
  updated_at timestamptz default now(),
  unique (hostel_id)
);

create table if not exists notifications (
  id text primary key,
  hostel_id uuid references hostels (id) on delete cascade,
  city text not null default 'Hyderabad',
  area text not null default 'KPHB',
  hostel_name text not null,
  image_url text not null,
  title text not null,
  time text not null,
  message text not null,
  created_at timestamptz default now()
);

-- Legacy stays table (kept for compatibility)
create table if not exists stays (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users (id) on delete cascade,
  full_name text not null,
  room_number integer not null default 0,
  joining_date text not null default '',
  room_type text not null,
  amount double precision not null,
  hostel_name text not null,
  hostel_address text not null,
  phone_number text not null,
  created_at timestamptz default now()
);

alter publication supabase_realtime add table food_menus;
alter publication supabase_realtime add table notifications;

alter table hostels enable row level security;
alter table sharing_types enable row level security;
alter table profiles enable row level security;
alter table food_menus enable row level security;
alter table notifications enable row level security;
alter table stays enable row level security;

drop policy if exists "Anyone can read hostels" on hostels;
create policy "Anyone can read hostels"
  on hostels for select to authenticated, anon using (true);

drop policy if exists "Anyone can read sharing types" on sharing_types;
create policy "Anyone can read sharing types"
  on sharing_types for select to authenticated, anon using (true);

drop policy if exists "Users read own profile" on profiles;
create policy "Users read own profile"
  on profiles for select using (auth.uid() = id);

drop policy if exists "Users insert own profile" on profiles;
create policy "Users insert own profile"
  on profiles for insert with check (auth.uid() = id);

drop policy if exists "Users update own profile" on profiles;
create policy "Users update own profile"
  on profiles for update using (auth.uid() = id);

drop policy if exists "Authenticated manage food menus" on food_menus;
create policy "Authenticated manage food menus"
  on food_menus for all to authenticated using (true) with check (true);

drop policy if exists "Authenticated read notifications" on notifications;
create policy "Authenticated read notifications"
  on notifications for select to authenticated using (true);

drop policy if exists "Admins insert notifications" on notifications;
create policy "Admins insert notifications"
  on notifications for insert to authenticated
  with check (
    exists (
      select 1 from profiles
      where profiles.id = auth.uid() and profiles.is_admin = true
    )
  );

drop policy if exists "Admins update notifications" on notifications;
create policy "Admins update notifications"
  on notifications for update to authenticated
  using (
    exists (
      select 1 from profiles
      where profiles.id = auth.uid() and profiles.is_admin = true
    )
  );

drop policy if exists "Users can read own stays" on stays;
create policy "Users can read own stays"
  on stays for select using (auth.uid() = user_id);

drop policy if exists "Users can insert own stays" on stays;
create policy "Users can insert own stays"
  on stays for insert with check (auth.uid() = user_id);

-- Seed sharing types
insert into sharing_types (label, amount, sort_order) values
  ('1 Share', 8000, 1),
  ('2 Share', 7000, 2),
  ('3 Share', 6500, 3),
  ('4 Share', 6000, 4),
  ('5 Share', 5500, 5)
on conflict (label) do nothing;

-- Seed KPHB hostels
insert into hostels (name, address, city, area) values
  ('Manikanta Boys Hostel', 'LIG: 333, Road No: 3, KPHB Colony, Kukatpally', 'Hyderabad', 'KPHB'),
  ('Sri Venkateswara Men''s Hostel', 'MIG-102, Road No: 1, KPHB Phase 1, Kukatpally', 'Hyderabad', 'KPHB'),
  ('Comfort Stay PG', 'HIG-45, KPHB 4th Phase, Kukatpally', 'Hyderabad', 'KPHB'),
  ('Metro Living PG', 'Beside JNTU Metro, KPHB Colony, Hyderabad', 'Hyderabad', 'KPHB')
on conflict do nothing;

-- Profile avatar URL (safe to re-run)
alter table profiles add column if not exists avatar_url text;

-- Service / maintenance requests from residents
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

alter table service_requests enable row level security;

drop policy if exists "Users read own service requests" on service_requests;
create policy "Users read own service requests"
  on service_requests for select to authenticated
  using (
    auth.uid() = user_id
    or exists (
      select 1 from profiles
      where profiles.id = auth.uid() and profiles.is_admin = true
    )
  );

drop policy if exists "Users insert own service requests" on service_requests;
create policy "Users insert own service requests"
  on service_requests for insert to authenticated
  with check (auth.uid() = user_id);

drop policy if exists "Users update own service requests" on service_requests;
create policy "Users update own service requests"
  on service_requests for update to authenticated
  using (
    auth.uid() = user_id
    or exists (
      select 1 from profiles
      where profiles.id = auth.uid() and profiles.is_admin = true
    )
  );

-- Storage bucket for avatars (create in Dashboard if insert fails)
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

drop policy if exists "Avatar images are publicly accessible" on storage.objects;
create policy "Avatar images are publicly accessible"
  on storage.objects for select
  using (bucket_id = 'avatars');

drop policy if exists "Users can upload own avatar" on storage.objects;
create policy "Users can upload own avatar"
  on storage.objects for insert to authenticated
  with check (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Users can update own avatar" on storage.objects;
create policy "Users can update own avatar"
  on storage.objects for update to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "Users can delete own avatar" on storage.objects;
create policy "Users can delete own avatar"
  on storage.objects for delete to authenticated
  using (
    bucket_id = 'avatars'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- ============================================================
-- Roles, hostel specifications, scoped admin policies
-- ============================================================

alter table profiles add column if not exists role text not null default 'resident';
alter table profiles add column if not exists avatar_url text;

-- Email-based role promotion removed. Roles are managed only in Supabase
-- (see role_security.sql + bootstrap_super_admin.sql).

create or replace function public.current_user_role()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select role from profiles where id = auth.uid()),
    case when (select is_admin from profiles where id = auth.uid()) then 'admin' else 'resident' end,
    'resident'
  );
$$;

create or replace function public.is_super_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.current_user_role() = 'super_admin';
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
      public.current_user_role() = 'admin'
      and exists (
        select 1 from profiles
        where id = auth.uid()
          and hostel_id = target_hostel_id
      )
    );
$$;

create or replace function public.protect_profile_role()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'UPDATE' then
    if new.role is distinct from old.role or new.is_admin is distinct from old.is_admin then
      if not public.is_super_admin() then
        raise exception 'Only super admin can change roles';
      end if;
    end if;
  end if;
  return new;
end;
$$;

drop trigger if exists trg_protect_profile_role on profiles;
create trigger trg_protect_profile_role
before update on profiles
for each row execute function public.protect_profile_role();

create table if not exists hostel_specifications (
  id uuid primary key default gen_random_uuid(),
  hostel_id uuid not null references hostels (id) on delete cascade,
  title text not null,
  description text not null default '',
  icon_key text not null default 'wifi',
  sort_order int not null default 0,
  is_enabled boolean not null default true,
  created_at timestamptz default now()
);

alter table hostel_specifications enable row level security;

drop policy if exists "Anyone authenticated read specs" on hostel_specifications;
create policy "Anyone authenticated read specs"
  on hostel_specifications for select to authenticated using (true);

drop policy if exists "Managers write specs" on hostel_specifications;
create policy "Managers write specs"
  on hostel_specifications for all to authenticated
  using (public.manages_hostel(hostel_id))
  with check (public.manages_hostel(hostel_id));

-- Hostels write for super admin / managers
drop policy if exists "Super admin manage hostels" on hostels;
create policy "Super admin manage hostels"
  on hostels for all to authenticated
  using (public.is_super_admin())
  with check (public.is_super_admin());

drop policy if exists "Admins update own hostel" on hostels;
create policy "Admins update own hostel"
  on hostels for update to authenticated
  using (public.manages_hostel(id))
  with check (public.manages_hostel(id));

-- Tighten food menus
drop policy if exists "Authenticated manage food menus" on food_menus;
drop policy if exists "Read food menus" on food_menus;
create policy "Read food menus"
  on food_menus for select to authenticated using (true);

drop policy if exists "Managers write food menus" on food_menus;
create policy "Managers write food menus"
  on food_menus for all to authenticated
  using (public.manages_hostel(hostel_id))
  with check (public.manages_hostel(hostel_id));

-- Notifications: managers scoped
drop policy if exists "Admins insert notifications" on notifications;
drop policy if exists "Admins update notifications" on notifications;
drop policy if exists "Managers write notifications" on notifications;
create policy "Managers write notifications"
  on notifications for all to authenticated
  using (public.manages_hostel(hostel_id))
  with check (public.manages_hostel(hostel_id));

-- Service requests: managers of hostel
drop policy if exists "Users read own service requests" on service_requests;
drop policy if exists "Users update own service requests" on service_requests;
drop policy if exists "Users insert own service requests" on service_requests;

create policy "Users insert own service requests"
  on service_requests for insert to authenticated
  with check (auth.uid() = user_id);

create policy "Users read service requests"
  on service_requests for select to authenticated
  using (
    auth.uid() = user_id
    or public.manages_hostel(hostel_id)
  );

create policy "Users update service requests"
  on service_requests for update to authenticated
  using (
    auth.uid() = user_id
    or public.manages_hostel(hostel_id)
  );

-- Super admin can update any profile (for role assignment)
drop policy if exists "Super admin update profiles" on profiles;
create policy "Super admin update profiles"
  on profiles for update to authenticated
  using (public.is_super_admin())
  with check (public.is_super_admin());

drop policy if exists "Super admin read profiles" on profiles;
create policy "Super admin read profiles"
  on profiles for select to authenticated
  using (public.is_super_admin() or auth.uid() = id);

drop policy if exists "Admin read hostel profiles" on profiles;
create policy "Admin read hostel profiles"
  on profiles for select to authenticated
  using (
    public.current_user_role() = 'admin'
    and hostel_id = (select hostel_id from profiles p where p.id = auth.uid())
  );

create or replace function public.current_user_hostel_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select hostel_id from profiles where id = auth.uid();
$$;

drop policy if exists "Admin read hostel profiles" on profiles;
create policy "Admin read hostel profiles"
  on profiles for select to authenticated
  using (
    public.current_user_role() = 'admin'
    and hostel_id = public.current_user_hostel_id()
  );
-- ============================================================
-- Role security hardening (run in Supabase SQL editor)
-- - Signup always creates residents
-- - Clients cannot self-promote via insert/update
-- - Super admin assigns admins only through assign_user_role()
-- - First super_admin is created ONLY via bootstrap_super_admin.sql
-- ============================================================

alter table profiles add column if not exists role text not null default 'resident';
alter table profiles add column if not exists is_admin boolean not null default false;

-- Force resident on every client insert (ignore any role/is_admin payload)
create or replace function public.enforce_profile_privileges()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if tg_op = 'INSERT' then
    new.role := 'resident';
    new.is_admin := false;
    return new;
  end if;

  if tg_op = 'UPDATE' then
    -- Allow privileged role changes only from assign_user_role / bootstrap
    if current_setting('app.allow_role_change', true) = 'on' then
      new.is_admin := new.role in ('admin', 'super_admin');
      return new;
    end if;

    -- Strip any attempt to change privileged fields from the client
    new.role := old.role;
    new.is_admin := old.is_admin;
    return new;
  end if;

  return new;
end;
$$;

drop trigger if exists trg_protect_profile_role on profiles;
drop trigger if exists trg_enforce_profile_privileges on profiles;
create trigger trg_enforce_profile_privileges
before insert or update on profiles
for each row execute function public.enforce_profile_privileges();

create or replace function public.current_user_role()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(
    (select role from profiles where id = auth.uid()),
    'resident'
  );
$$;

create or replace function public.is_super_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.current_user_role() = 'super_admin';
$$;

create or replace function public.current_user_hostel_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select hostel_id from profiles where id = auth.uid();
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
      public.current_user_role() = 'admin'
      and public.current_user_hostel_id() = target_hostel_id
    );
$$;

-- Super admin assigns resident/admin only (never super_admin from the app)
create or replace function public.assign_user_role(
  target_user_id uuid,
  new_role text,
  target_hostel_id uuid default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_super_admin() then
    raise exception 'Only super admin can assign roles';
  end if;

  if new_role not in ('resident', 'admin') then
    raise exception 'App may only assign resident or admin roles';
  end if;

  if new_role = 'admin' and target_hostel_id is null then
    raise exception 'Admin must be assigned to a hostel';
  end if;

  -- Do not demote/overwrite an existing super_admin via the app
  if exists (
    select 1 from profiles
    where id = target_user_id and role = 'super_admin'
  ) then
    raise exception 'Cannot change a super admin from the app';
  end if;

  perform set_config('app.allow_role_change', 'on', true);

  update profiles
  set
    role = new_role,
    is_admin = (new_role = 'admin'),
    hostel_id = case
      when new_role = 'admin' then target_hostel_id
      else coalesce(target_hostel_id, hostel_id)
    end
  where id = target_user_id;
end;
$$;

revoke all on function public.assign_user_role(uuid, text, uuid) from public;
grant execute on function public.assign_user_role(uuid, text, uuid) to authenticated;

-- Keep helper execute grants for authenticated
grant execute on function public.current_user_role() to authenticated;
grant execute on function public.is_super_admin() to authenticated;
grant execute on function public.current_user_hostel_id() to authenticated;
grant execute on function public.manages_hostel(uuid) to authenticated;
