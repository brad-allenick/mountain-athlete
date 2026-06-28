-- Mountain Athlete Workout Tracker
-- Run this in the Supabase SQL Editor (same project as wx, or a new one)

-- ─────────────────────────────────────────────
-- workout_sessions  (one row per gym visit)
-- ─────────────────────────────────────────────
create table workout_sessions (
  id           uuid        primary key default gen_random_uuid(),
  workout_date date        not null default current_date,
  day_label    text        not null,   -- 'A', 'B', or any future label
  started_at   timestamptz,            -- when the user tapped "Log Day X" (workout start)
  ended_at     timestamptz,            -- when they submitted the log modal (workout end)
  notes        text,                   -- optional free-text for the session
  created_at   timestamptz not null default now()
);

-- ─────────────────────────────────────────────
-- workout_sets  (one row per set)
-- ─────────────────────────────────────────────
create table workout_sets (
  id               uuid        primary key default gen_random_uuid(),
  session_id       uuid        not null references workout_sessions(id) on delete cascade,
  exercise_name    text        not null,       -- 'Back Squat', 'RDL', etc. — plain text, no lookup table
  set_number       smallint    not null,       -- 1, 2, 3 …
  weight_lbs       numeric(6,2),               -- null = bodyweight or unweighted
  reps             smallint,                   -- null = timed set
  duration_seconds smallint,                  -- null = rep-based set
  rpe              smallint check (rpe between 1 and 10),  -- optional Rate of Perceived Exertion
  notes            text,                       -- e.g. "felt heavy", "paused reps"
  created_at       timestamptz not null default now()
);

-- ─────────────────────────────────────────────
-- Indexes
-- ─────────────────────────────────────────────
create index on workout_sessions (workout_date desc);
create index on workout_sets (session_id);
create index on workout_sets (exercise_name);

-- ─────────────────────────────────────────────
-- RLS
-- This is a personal app with the anon key embedded in the HTML.
-- Disable RLS for simplicity — the data isn't sensitive.
-- If you later add Supabase Auth, re-enable and add user_id policies.
-- ─────────────────────────────────────────────
alter table workout_sessions disable row level security;
alter table workout_sets     disable row level security;
