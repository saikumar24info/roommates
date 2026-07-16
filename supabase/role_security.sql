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
