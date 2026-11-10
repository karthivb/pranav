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

## Supabase setup (optional)

1. Create a Supabase project.
2. Open SQL Editor and run `supabase/schema.sql`.
3. Configure authentication providers in Supabase.
4. Set `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` (or the publishable key) in your local `.env.local` and in Netlify site environment variables.
5. Redeploy the site.

**Security notes:** Only put the Supabase URL and publishable/anon key in browser environment variables. Never expose a service-role key. Review authentication, parental consent, data retention, and privacy requirements before collecting children's data. The current UI stores progress locally by default; cloud syncing requires authenticated users and additional product wiring before it is production-ready. Public leaderboards should be reviewed carefully for child privacy.

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
