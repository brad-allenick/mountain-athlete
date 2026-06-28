# Mountain Athlete Workout Tracker

A self-contained HTML workout tracker built for a mid-30s mountain athlete — backcountry skiing, mountain biking, hiking, trail running, backpacking. No build step, no dependencies, opens directly in any browser.

## What it is

A single HTML file with inline CSS and JS that functions as a personal gym planner and workout logger. Designed to be added to your iPhone home screen as a pseudo-app.

**Two full-body training days:**

- **Day A — Legs, Power & Core** (priority day for one-session weeks): back squat/goblet squat, RDL, Bulgarian split squat, weighted step-up, Pallof press, dead bug
- **Day B — Pull, Press & Carry**: weighted pull-up/lat pulldown, single-arm DB row, Z-press, face pulls, farmer's carry, Copenhagen side plank, suitcase deadlift

## Features

- Per-exercise weight inputs that auto-save to `localStorage`
- Expandable form cues for every exercise
- **Per-set workout logging** with weight, reps, and optional RPE (1–10)
- Session start/end time tracking (for duration)
- Workout history and per-set detail view
- Weight trend charts per exercise (pure Canvas 2D, no charting library)
- CSV export of full session history
- **Supabase integration** for cross-device persistent storage

## Setup

### 1. Run the SQL schema

In your Supabase project's SQL Editor, run `supabase_schema.sql`. This creates two tables:

- `workout_sessions` — one row per gym visit (date, day label, start/end time, notes)
- `workout_sets` — one row per set (exercise name, set number, weight, reps, RPE)

### 2. Connect Supabase in the app

Open `mountain-athlete-workout.html` in a browser, tap **⚙ Supabase Setup** in the history section, and enter your Supabase **Project URL** and **anon/public key** (found in your project under Settings → API). The app tests the connection and saves credentials to `localStorage`.

### 3. Host it (for iOS / cross-device)

To add to your iPhone home screen and avoid iOS CORS restrictions on local files, host the HTML file somewhere with HTTPS. Free options:

- **Cloudflare Pages** — drag the file into a new Pages project, get a `*.pages.dev` URL
- **Netlify Drop** — drag onto [app.netlify.com/drop](https://app.netlify.com/drop), get a `*.netlify.app` URL instantly

Then in Safari: open the hosted URL → Share → Add to Home Screen.

## Files

| File | Description |
|---|---|
| `mountain-athlete-workout.html` | The app — single file, self-contained |
| `supabase_schema.sql` | Run once in Supabase SQL Editor to create tables |
| `PROJECT_CONTEXT.md` | Full build history and design decisions |

## Design notes

- Yoga already covers flexibility/balance, so gym work targets what sport + desk job actually need: explosive leg power, single-leg stability, posterior chain, anti-rotation core, pulling strength, loaded carries, and posture correction (face pulls, band pull-aparts, dead hangs, t-spine work)
- Each day stands alone for one-session weeks — Day A is always the priority
- Weight inputs stay in `localStorage` (per-device quick reference); session history goes to Supabase (cross-device)
- No external JS libraries — Supabase JS loaded via CDN, everything else is vanilla
