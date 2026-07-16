-- Fix: hostel create blocked by RLS for super admin
-- Run this entire script in Supabase SQL Editor.

alter table profiles add column if not exists role text not null default 'resident';
alter table profiles add column if not exists is_admin boolean not null default false;

-- Ensure privilege helpers exist
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

-- Re-promote known owner (safe if already set)
do $$
begin
  perform set_config('app.allow_role_change', 'on', true);
  update profiles
  set role = 'super_admin', is_admin = true
  where lower(email) = lower('saikumars@gmail.com');
end $$;

-- Explicit hostels policies
alter table hostels enable row level security;

drop policy if exists "Anyone can read hostels" on hostels;
create policy "Anyone can read hostels"
  on hostels for select to authenticated, anon
  using (true);

drop policy if exists "Super admin manage hostels" on hostels;
drop policy if exists "Super admin insert hostels" on hostels;
drop policy if exists "Super admin update hostels" on hostels;
drop policy if exists "Super admin delete hostels" on hostels;
drop policy if exists "Admins update own hostel" on hostels;

create policy "Super admin insert hostels"
  on hostels for insert to authenticated
  with check (public.is_super_admin());

create policy "Super admin update hostels"
  on hostels for update to authenticated
  using (public.is_super_admin())
  with check (public.is_super_admin());

create policy "Super admin delete hostels"
  on hostels for delete to authenticated
  using (public.is_super_admin());

create policy "Admins update own hostel"
  on hostels for update to authenticated
  using (
    public.current_user_role() = 'admin'
    and id = (select hostel_id from profiles where id = auth.uid())
  )
  with check (
    public.current_user_role() = 'admin'
    and id = (select hostel_id from profiles where id = auth.uid())
  );

-- Secure RPC (bypasses RLS after verifying super admin)
create or replace function public.create_hostel(
  p_name text,
  p_address text,
  p_city text default 'Hyderabad',
  p_area text default 'KPHB'
)
returns public.hostels
language plpgsql
security definer
set search_path = public
as $$
declare
  created public.hostels;
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  if not public.is_super_admin() then
    raise exception 'Only super admin can create hostels. Current role: %',
      public.current_user_role();
  end if;

  insert into hostels (name, address, city, area)
  values (p_name, p_address, p_city, p_area)
  returning * into created;

  -- Seed empty menu row so admin can edit later
  insert into food_menus (hostel_id, city, area, hostel_name, menu_data, updated_at)
  values (created.id, created.city, created.area, created.name, '{}'::jsonb, now())
  on conflict (hostel_id) do nothing;

  return created;
end;
$$;

create or replace function public.update_hostel(
  p_hostel_id uuid,
  p_name text,
  p_address text,
  p_city text,
  p_area text
)
returns public.hostels
language plpgsql
security definer
set search_path = public
as $$
declare
  updated public.hostels;
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  if not (
    public.is_super_admin()
    or (
      public.current_user_role() = 'admin'
      and (select hostel_id from profiles where id = auth.uid()) = p_hostel_id
    )
  ) then
    raise exception 'Not allowed to update this hostel';
  end if;

  update hostels
  set name = p_name,
      address = p_address,
      city = p_city,
      area = p_area
  where id = p_hostel_id
  returning * into updated;

  if updated.id is null then
    raise exception 'Hostel not found';
  end if;

  update food_menus
  set hostel_name = p_name,
      city = p_city,
      area = p_area
  where hostel_id = p_hostel_id;

  return updated;
end;
$$;

revoke all on function public.create_hostel(text, text, text, text) from public;
revoke all on function public.update_hostel(uuid, text, text, text, text) from public;
grant execute on function public.create_hostel(text, text, text, text) to authenticated;
grant execute on function public.update_hostel(uuid, text, text, text, text) to authenticated;
grant execute on function public.is_super_admin() to authenticated;
grant execute on function public.current_user_role() to authenticated;

-- Quick check (should show super_admin for your account)
select email, role, is_admin from profiles where lower(email) = lower('saikumars@gmail.com');
