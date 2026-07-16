-- ============================================================
-- ONE-TIME: bootstrap the first Super Admin
-- Adds missing columns if needed, then promotes the account.
-- ============================================================

-- Ensure role columns exist (safe to re-run)
alter table profiles add column if not exists role text not null default 'resident';
alter table profiles add column if not exists is_admin boolean not null default false;

do $$
declare
  target_email text := 'saikumars@gmail.com';
begin
  if not exists (select 1 from profiles where lower(email) = lower(target_email)) then
    raise exception 'No profile found for %. Sign up in the app first, then run this again.', target_email;
  end if;

  -- Allow role change even if security trigger is installed
  begin
    perform set_config('app.allow_role_change', 'on', true);
  exception when others then
    null;
  end;

  update profiles
  set role = 'super_admin', is_admin = true
  where lower(email) = lower(target_email);

  raise notice 'Promoted % to super_admin', target_email;
end $$;
