-- Ensure hostel_specifications exists and can be soft-seeded by any logged-in user.
-- Run in Supabase SQL Editor.

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

-- Keep manager write policy if helpers exist; otherwise create a permissive insert for empty seed via RPC only
drop policy if exists "Managers write specs" on hostel_specifications;
do $$
begin
  if exists (
    select 1 from pg_proc p
    join pg_namespace n on n.oid = p.pronamespace
    where n.nspname = 'public' and p.proname = 'manages_hostel'
  ) then
    execute $policy$
      create policy "Managers write specs"
        on hostel_specifications for all to authenticated
        using (public.manages_hostel(hostel_id))
        with check (public.manages_hostel(hostel_id))
    $policy$;
  end if;
end $$;

-- Soft seed: any authenticated user can ensure defaults exist for a hostel
create or replace function public.ensure_hostel_specifications(p_hostel_id uuid)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  if not exists (select 1 from hostels where id = p_hostel_id) then
    raise exception 'Hostel not found';
  end if;

  if exists (
    select 1 from hostel_specifications where hostel_id = p_hostel_id limit 1
  ) then
    return;
  end if;

  insert into hostel_specifications
    (hostel_id, icon_key, title, description, sort_order, is_enabled)
  values
    (p_hostel_id, 'wifi', 'Wifi', 'Enjoy fast and reliable 24/7 wifi access in every room, ensuring you stay connected at all times.', 1, true),
    (p_hostel_id, 'ac', 'Ac Rooms', 'Experience comfort in our air-conditioned rooms, providing a cool and pleasant environment.', 2, true),
    (p_hostel_id, 'food', 'Homely Food', 'Our meals will remind you of home. You can also cook for yourself or place orders as needed.', 3, true),
    (p_hostel_id, 'elevator', 'Elevator', 'Our building features an elevator for convenient access from the ground floor to the top floor at any time.', 4, true),
    (p_hostel_id, 'ro_water', 'RO Water', 'Stay hydrated with clean, chilled RO water available on every floor.', 5, true),
    (p_hostel_id, 'hot_water', 'Hot Water', 'Enjoy 24/7 hot water availability on every floor for your convenience.', 6, true),
    (p_hostel_id, 'lockers', 'Lockers', 'Your safety is our priority. Each room is equipped with individual lockers for secure storage.', 7, true),
    (p_hostel_id, 'cctv', 'CCTV', 'Our building is under continuous CCTV surveillance for enhanced security.', 8, true);
end;
$$;

revoke all on function public.ensure_hostel_specifications(uuid) from public;
grant execute on function public.ensure_hostel_specifications(uuid) to authenticated;

-- Refresh PostgREST schema cache
notify pgrst, 'reload schema';
