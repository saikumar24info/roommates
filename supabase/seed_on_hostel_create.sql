-- ============================================================
-- Seed defaults when a hostel is created + per-hostel rent plans
-- Run in Supabase SQL Editor (safe to re-run).
-- ============================================================

-- Required helper (no-op replace if already defined elsewhere)
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

-- Specifications table (was missing in your DB)
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

create table if not exists hostel_rent_plans (
  id uuid primary key default gen_random_uuid(),
  hostel_id uuid not null references hostels (id) on delete cascade,
  label text not null,
  amount numeric not null,
  sort_order int not null default 0,
  created_at timestamptz default now(),
  unique (hostel_id, label)
);

alter table hostel_rent_plans enable row level security;

drop policy if exists "Anyone authenticated read rent plans" on hostel_rent_plans;
create policy "Anyone authenticated read rent plans"
  on hostel_rent_plans for select to authenticated using (true);

drop policy if exists "Managers write rent plans" on hostel_rent_plans;
create policy "Managers write rent plans"
  on hostel_rent_plans for all to authenticated
  using (public.manages_hostel(hostel_id))
  with check (public.manages_hostel(hostel_id));

create or replace function public.seed_hostel_defaults(
  p_hostel_id uuid,
  p_menu_data jsonb default null
)
returns void
language plpgsql
security definer
set search_path = public
as $$
declare
  h public.hostels;
begin
  select * into h from hostels where id = p_hostel_id;
  if h.id is null then
    raise exception 'Hostel not found';
  end if;

  if auth.uid() is not null
     and not public.is_super_admin()
     and not public.manages_hostel(p_hostel_id) then
    raise exception 'Not allowed to seed this hostel';
  end if;

  -- Food menu
  insert into food_menus (hostel_id, city, area, hostel_name, menu_data, updated_at)
  values (
    h.id,
    h.city,
    h.area,
    h.name,
    coalesce(p_menu_data, '{}'::jsonb),
    now()
  )
  on conflict (hostel_id) do update
    set menu_data = coalesce(excluded.menu_data, food_menus.menu_data),
        hostel_name = excluded.hostel_name,
        city = excluded.city,
        area = excluded.area,
        updated_at = now();

  if p_menu_data is not null and p_menu_data <> '{}'::jsonb then
    update food_menus
    set menu_data = p_menu_data, updated_at = now()
    where hostel_id = h.id;
  end if;

  -- Specifications
  if not exists (select 1 from hostel_specifications where hostel_id = h.id limit 1) then
    insert into hostel_specifications
      (hostel_id, icon_key, title, description, sort_order, is_enabled)
    values
      (h.id, 'wifi', 'Wifi', 'Enjoy fast and reliable 24/7 wifi access in every room.', 1, true),
      (h.id, 'ac', 'Ac Rooms', 'Experience comfort in our air-conditioned rooms.', 2, true),
      (h.id, 'food', 'Homely Food', 'Our meals will remind you of home.', 3, true),
      (h.id, 'elevator', 'Elevator', 'Convenient elevator access across floors.', 4, true),
      (h.id, 'ro_water', 'RO Water', 'Clean chilled RO water on every floor.', 5, true),
      (h.id, 'hot_water', 'Hot Water', '24/7 hot water availability.', 6, true),
      (h.id, 'lockers', 'Lockers', 'Individual lockers for secure storage.', 7, true),
      (h.id, 'cctv', 'CCTV', 'Continuous CCTV surveillance for security.', 8, true);
  end if;

  -- Rent plans
  if not exists (select 1 from hostel_rent_plans where hostel_id = h.id limit 1) then
    insert into hostel_rent_plans (hostel_id, label, amount, sort_order)
    values
      (h.id, '1 Share', 8000, 1),
      (h.id, '2 Share', 7000, 2),
      (h.id, '3 Share', 6500, 3),
      (h.id, '4 Share', 6000, 4),
      (h.id, '5 Share', 5500, 5);
  end if;

  -- Welcome notification
  if not exists (select 1 from notifications where hostel_id = h.id limit 1) then
    insert into notifications (
      id, hostel_id, city, area, hostel_name, image_url, title, time, message
    ) values (
      'welcome-' || replace(h.id::text, '-', ''),
      h.id,
      h.city,
      h.area,
      h.name,
      'https://picsum.photos/seed/hostelwelcome/800/400',
      'Welcome to ' || h.name,
      'Today',
      'Your hostel profile is ready. Check the food menu, amenities, rent plans, and stay details in the app.'
    );
  end if;
end;
$$;

-- Drop old overloads if they exist, then create the single create_hostel
drop function if exists public.create_hostel(text, text, text, text);
drop function if exists public.create_hostel(text, text, text, text, jsonb);

create or replace function public.create_hostel(
  p_name text,
  p_address text,
  p_city text default 'Hyderabad',
  p_area text default 'KPHB',
  p_menu_data jsonb default null
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

  perform public.seed_hostel_defaults(created.id, p_menu_data);

  return created;
end;
$$;

revoke all on function public.seed_hostel_defaults(uuid, jsonb) from public;
revoke all on function public.create_hostel(text, text, text, text, jsonb) from public;
grant execute on function public.seed_hostel_defaults(uuid, jsonb) to authenticated;
grant execute on function public.create_hostel(text, text, text, text, jsonb) to authenticated;
