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
