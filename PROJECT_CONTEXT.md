# Mountain Athlete Workout Plan — Project Context

This doc summarizes the conversation history and current state of this project so a fresh Claude Code session in VSCode has full context. Paste this whole file into the chat (or just reference it / `@PROJECT_CONTEXT.md`) when starting the session.

## What this is

A single self-contained HTML file (`mountain-athlete-workout.html`) — no build step, no dependencies — that serves as a personal gym workout plan + tracker for a mid-30s male "mountain athlete" (backcountry/resort skiing, mountain biking, hiking, trail running, backpacking, hot power yoga 1x/week, desk job). Designed to be opened directly in a browser or run as an iOS home-screen pseudo-app.

**Current file location:** `/mnt/user-data/outputs/mountain-athlete-workout.html` (~1,160 lines, single file: inline CSS + inline JS, no external JS libraries).

## Person's training context (for any future programming changes)

- Mid-30s male, desk job (sits/stands most of day)
- Backcountry + hard resort skiing, mountain biking, hiking, occasional trail running, backpacking 1-2x/year, yard/house work, heavy snow shoveling in winter
- Hot power yoga 1x/week — already covers flexibility/balance/body awareness
- Wants to hit the gym 1-2x/week, inconsistently — needs a routine resilient to missing a week
- Likes the gym when he gets there but doesn't always fit it in

## Design philosophy baked into the plan

Two full-body days, each able to stand alone (since some weeks are one-session weeks):

- **Day A — Legs, Power & Core** (the priority day if only one session fits): back squat/goblet squat, RDL, Bulgarian split squat, weighted step-up w/ knee drive, Pallof press, dead bug. Warm-up: hip 90/90, glute bridge + leg curl, lateral band walks, world's greatest stretch.
- **Day B — Pull, Press & Carry**: weighted pull-up/lat pulldown, single-arm DB row, DB Z-press/seated press, face pulls, farmer's carry, Copenhagen side plank, suitcase deadlift. Warm-up: cat-cow + t-spine rotation, band pull-aparts, dead hang.

Rationale: yoga already covers mobility/flexibility, so gym work targets what sport + desk job actually need — explosive leg power, single-leg stability, posterior chain, rotational/anti-rotation core, pulling strength and loaded carries for pack-hauling, and posture correction (face pulls, band pull-aparts, dead hangs, t-spine work) to counteract desk sitting.

## Feature build history (chronological)

1. **V1 — Initial plan**: Static HTML page, dark "alpine" themed design (mountain/snow color palette, Bebas Neue + DM Sans + DM Mono fonts), two-day split as above, programming notes (progression, seasonal adjustment for ski season vs off-season, desk posture priorities, one-day-week strategy).

2. **V2 — Weight inputs + Google links**: Added a number input field next to every weighted exercise (saves to `localStorage` automatically on change, shows a toast confirmation). Added small "example" links next to non-obvious exercise names that open a Google search in a new tab (e.g. Pallof Press, Bulgarian Split Squat, Suitcase Deadlift, Copenhagen Side Plank, Z-Press). Common lifts (squat, row) don't get links.

3. **V3 — Form cues + session logging + trend charts**: Added an expandable "Form cues" toggle under every single exercise (warm-up and main lifts) with 4-5 specific setup/technique bullet points. Added a "Log Day A/B Workout" button at the bottom of each day that snapshots current weight-input values into a persistent **session history** (stored in `localStorage` under key `maw-history-v2`, array of `{id, day, ts (ISO timestamp), weights: {exerciseId: value}}`). Built a **Workout History & Weight Trends** section at the bottom of the page with two tabs:
   - **Session Log tab**: chronological list of logged sessions, each showing day, date/time, all weights recorded, and a delete (✕) button per entry.
   - **Weight Trends tab**: dropdown to pick an exercise (only shows exercises that have ≥2 logged data points), renders a hand-drawn canvas line chart (gradient area fill, dots, grid lines, date labels on x-axis, weight axis on y-axis) — no external charting library, pure Canvas 2D API.

4. **V4 — CSV export + Google Sheets sync**: Added an export bar above the History section with three buttons:
   - **Export CSV**: client-side only, builds a CSV blob from full history and triggers a download (`mountain-athlete-log.csv`). Works everywhere, no setup.
   - **Sync to Google Sheets**: POSTs any *unsynced* session entries (tracked via a `Set` of already-synced entry IDs in `localStorage` key `maw-synced-ids`) to a user-configured Google Apps Script Web App URL (stored in `localStorage` key `maw-sheets-url`). Uses `mode: 'no-cors'` fetch since Apps Script doesn't return readable CORS headers to a plain fetch.
   - **⚙ Sheets Setup**: opens a modal with full step-by-step instructions, including the complete copy-pasteable Apps Script code (creates a "Workouts" sheet with header row on first run, appends one row per synced session), deployment instructions (Deploy → New deployment → Web app → Execute as Me → Anyone has access), and a field to paste/save the resulting Web App URL.
   - Modal includes a noted caveat: **Safari on iOS blocks cross-origin fetch from a `file://` opened HTML page**, so Sheets sync won't work if the file is just opened locally on iPhone — CSV export still will. Sync requires the file to be actually hosted (see below).

## Known constraints / open items discussed

- **localStorage is per-browser/per-device.** No cross-device sync currently. All weights, history, sheets-URL, and synced-IDs tracking live in the browser's localStorage on whatever device/browser last opened the file.
- **iOS file handling friction**: Files app previews HTML rather than opening it in Safari, and there's no built-in "Add to Home Screen" from the Files preview. Workarounds discussed: Share sheet → "Open in Safari" (when available), or — the recommended path — host the file somewhere real (Netlify Drop was suggested: drag file onto app.netlify.com/drop, get an instant URL, no account needed) and use that URL on iPhone, then Share → Add to Home Screen for a fullscreen pseudo-app icon.
- **Strava API**: As of writing, Strava's new "Workout Log" + auto-populated Muscle Map features (announced May 21, 2026) are NOT yet exposed via a public developer API — they're currently only available through ~14 private partner integrations (Hevy, JEFIT, Fitbod, Garmin, Whoop, COROS, etc.). Recommended interim path if Strava muscle-map sync is wanted: log workouts in Hevy (free, one of the 14 partners), which auto-syncs to Strava with full exercise/muscle-map data. The old Strava V3 API (activity upload, OAuth2, webhooks) still works for posting basic `WeightTraining` activities with duration/HR/description, just not structured per-set data yet.
- **Apple HealthKit**: Cannot be accessed from a plain web page (no web API for HealthKit; it's sandboxed to native iOS apps / limited PWA scenarios). Apple Watch HR during a workout auto-logs to Health from the Watch itself, but there's no way to link it programmatically to a specific logged session from this HTML tool. A native app (Swift, or React Native/Expo) would be required for real HealthKit read/write + Strava OAuth + cloud-synced weight history — discussed as a future "productionize" path but explicitly shelved for now ("we'll shelve that for now").

## Likely next steps if resumed in Claude Code

Pick up any of these threads depending on what the person wants:
- Polish/host the current HTML file (e.g., scaffold a minimal static hosting setup, or a small Node/Express or Vercel deployment) to solve the iOS CORS + cross-device sync problem properly.
- Build the "real" backend version: Supabase or Firebase for persistent cross-device storage of weights/history, replacing localStorage.
- Build a small native or PWA wrapper that can talk to HealthKit and/or Strava OAuth, per the "productionize" discussion above.
- Continue iterating on the workout programming itself (exercise selection, periodization, seasonal phase changes) — person has a sustained, sophisticated interest in this and revisits it often per long-term memory.

## File manifest

- `mountain-athlete-workout.html` — the actual deliverable, single file, self-contained, ~1,160 lines (inline `<style>` and `<script>`, no external JS deps beyond a Google Fonts `@import`).
