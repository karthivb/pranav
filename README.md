# Knowledge Quest

A playful, responsive learning dashboard for curious kids. Explore subjects, complete bite-size challenges, play five mini games, and learn the building blocks of game development.

## Features

- Eight subject paths: Mathematics, Chemistry, Physics, AI, Computer Science, Latest Inventions, Universe & Space, and General Knowledge.
- Light and dark themes, persisted locally.
- Five separate mini-game experiences: Turbo Car Racer, Veggie Slice, Mine Blast (crystal matching), River Boat Adventure, and SpaceX–NASA Space Explorer.
- Starter coding lessons for moving shapes, collecting stars, Snake, car games, and rocket launches.
- Local-first student points and completion history.
- Optional Supabase schema for student profiles, games, sessions, scores, and leaderboard view.
- Netlify build configuration and responsive layout.

## Run locally

Requirements: Node.js 20+ recommended.

```sh
npm install
cp .env.example .env.local
npm run dev
```

The app runs in local demo mode without Supabase configuration. Local progress is stored in browser localStorage and is specific to the current browser/device.

## Supabase setup and student login

Use a **separate Supabase project for Knowledge Quest**. Do not reuse the Supabase project or keys from a trading or other application.

1. In the Supabase dashboard, create a project named `Knowledge Quest`.
2. Open **SQL Editor → New query**, paste `supabase/schema.sql`, and run it once.
3. In **Authentication → Providers → Email**, enable Email sign-in. Decide whether email confirmation is required.
4. In **Authentication → URL Configuration**, set the Site URL to your local development URL while testing (for example `http://localhost:5173`) and add your deployed Netlify URL to Redirect URLs when you deploy.
5. Copy the project's **Project URL** and **Publishable key** from **Project Settings → API**.
6. For local development, copy `.env.example` to `.env.local` and set:
   - `VITE_SUPABASE_URL` = the Knowledge Quest Project URL
   - `VITE_SUPABASE_PUBLISHABLE_KEY` = the Knowledge Quest publishable key
7. In Netlify, open **Site configuration → Environment variables** and add the same two variables. Trigger a new deploy after the variables are saved.
8. Open Knowledge Quest → **Settings → Supabase account**. Choose **Create account** or **Sign in**.

The Settings screen now includes email/password sign-up, sign-in, and sign-out. When a user signs in, the app creates or updates their own profile row. If email confirmation is enabled, the learner must confirm the email before signing in.

**Security and child privacy:** Never put a Supabase secret/service-role key in frontend variables or GitHub. Only the publishable key is intended for browser use. The schema restricts student profile, session, and score access to the signed-in student. The current leaderboard is intentionally not a cross-student public leaderboard; implement a privacy-reviewed, server-controlled aggregate before showing children's names or scores to other users. Obtain appropriate parental consent and review applicable child privacy obligations before collecting real student data.

The app continues to work in local demo mode if Supabase environment variables are not configured. Local browser progress is not automatically migrated into a cloud account.

## Build

```sh
npm run build
npm run preview
```

## Deploy to Netlify

Connect this repository to Netlify. The included `netlify.toml` sets build command `npm run build`, publish directory `dist`, and SPA fallback routing. Add the optional Supabase environment variables before deployment if needed.

## Project structure

```
src/
  App.tsx        # Learning dashboard, subject challenges, mini games
  main.tsx       # React entry point
  styles.css     # Responsive dark/light theme
supabase/
  schema.sql     # Optional tables, row-level security and leaderboard view
.env.example
netlify.toml
vite.config.ts
```

## Current implementation notes

- Arcade mini games are interactive educational prototypes, not production game-engine builds.
- The code sandbox deliberately does not execute arbitrary visitor-provided JavaScript; it previews learning snippets instead.
- Cloud score writes are attempted only when Supabase variables and an authenticated user are present. Sign-in UI, robust server-side score validation, parental consent, and full cloud progress syncing should be completed before a public launch.
