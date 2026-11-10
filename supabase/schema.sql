-- Knowledge Quest schema. Run in Supabase SQL Editor.
create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'Young Explorer',
  avatar_emoji text not null default '🚀',
  created_at timestamptz not null default now()
);

create table if not exists public.games (
  id text primary key,
  title text not null,
  category text not null default 'arcade',
  description text not null,
  emoji text not null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

insert into public.games (id,title,category,description,emoji) values
 ('turbo-car-racer','Turbo Car Racer','racing','Steer around road hazards and collect science stars.','🏎️'),
 ('veggie-slice','Veggie Slice','arcade','Slice falling fruit and vegetables; avoid the tricky items.','🥕'),
 ('mine-blast','Mine Blast','puzzle','Match glowing crystals to clear the board.','💎'),
 ('river-boat-adventure','River Boat Adventure','adventure','Navigate the river, gather supplies, and avoid rocks.','🛶'),
 ('space-explorer','SpaceX–NASA Space Explorer','space','Explore the solar system and collect mission data.','🚀')
on conflict (id) do update set title=excluded.title, description=excluded.description, emoji=excluded.emoji;

create table if not exists public.game_sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  game_id text not null references public.games(id),
  score integer not null default 0 check (score >= 0),
  duration_seconds integer not null default 0 check (duration_seconds >= 0),
  metadata jsonb not null default '{}'::jsonb,
  played_at timestamptz not null default now()
);

create table if not exists public.student_scores (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.profiles(id) on delete cascade,
  activity_type text not null check (activity_type in ('lesson','quiz','game','coding-task')),
  activity_id text not null,
  points integer not null default 0 check (points >= 0),
  best_score integer not null default 0 check (best_score >= 0),
  completed_at timestamptz not null default now(),
  unique (user_id, activity_type, activity_id)
);

create index if not exists game_sessions_leaderboard_idx on public.game_sessions(game_id, score desc, played_at);
create index if not exists student_scores_user_idx on public.student_scores(user_id, completed_at desc);

alter table public.profiles enable row level security;
alter table public.games enable row level security;
alter table public.game_sessions enable row level security;
alter table public.student_scores enable row level security;

create policy "Profiles are readable by authenticated learners" on public.profiles
 for select to authenticated using (true);
create policy "Learners create own profile" on public.profiles
 for insert to authenticated with check (auth.uid() = id);
create policy "Learners update own profile" on public.profiles
 for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);
create policy "Games are readable by everyone" on public.games
 for select to anon, authenticated using (is_active = true);
create policy "Learners read own sessions" on public.game_sessions
 for select to authenticated using (auth.uid() = user_id);
create policy "Learners record own sessions" on public.game_sessions
 for insert to authenticated with check (auth.uid() = user_id);
create policy "Learners read own scores" on public.student_scores
 for select to authenticated using (auth.uid() = user_id);
create policy "Learners write own scores" on public.student_scores
 for insert to authenticated with check (auth.uid() = user_id);
create policy "Learners update own scores" on public.student_scores
 for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Public leaderboard view exposes only display name, avatar and aggregate points.
create or replace view public.leaderboard
with (security_invoker = true) as
select p.id as user_id, p.display_name, p.avatar_emoji,
       coalesce(sum(s.points), 0)::bigint as total_points,
       coalesce(max(s.best_score), 0)::integer as best_score
from public.profiles p
left join public.student_scores s on s.user_id = p.id
group by p.id, p.display_name, p.avatar_emoji;

grant select on public.games to anon, authenticated;
grant select on public.leaderboard to authenticated;
