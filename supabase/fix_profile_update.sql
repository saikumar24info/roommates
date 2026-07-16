-- Safe profile field updates for the logged-in user (no role changes).
-- Run in Supabase SQL Editor.

alter table profiles add column if not exists avatar_url text;

create or replace function public.update_own_profile(
  p_first_name text,
  p_last_name text,
  p_phone text,
  p_job_title text
)
returns public.profiles
language plpgsql
security definer
set search_path = public
as $$
declare
  updated public.profiles;
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  update profiles
  set
    first_name = trim(p_first_name),
    last_name = trim(p_last_name),
    phone = trim(p_phone),
    job_title = nullif(trim(p_job_title), '')
  where id = auth.uid()
  returning * into updated;

  if updated.id is null then
    raise exception 'Profile not found';
  end if;

  return updated;
end;
$$;

create or replace function public.update_own_avatar(p_avatar_url text)
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'Not authenticated';
  end if;

  update profiles
  set avatar_url = case
    when p_avatar_url is null or trim(p_avatar_url) = '' then null
    else trim(p_avatar_url)
  end
  where id = auth.uid();
end;
$$;

revoke all on function public.update_own_profile(text, text, text, text) from public;
revoke all on function public.update_own_avatar(text) from public;
grant execute on function public.update_own_profile(text, text, text, text) to authenticated;
grant execute on function public.update_own_avatar(text) to authenticated;

-- Ensure avatars bucket exists
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

notify pgrst, 'reload schema';
