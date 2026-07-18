# Of The Pitch

An independent World Cup 2026 guide for travelling fans — visas and entry requirements, cross-border travel, fan zones, tickets, squad reviews, and where to watch every match.

Live at **[ofthepitch.com](https://ofthepitch.com)**. Not affiliated with FIFA or any national football association.

**Stack:** Next.js 16 · Tailwind CSS 4 · Supabase

See **[CLAUDE.md](CLAUDE.md)** for the full project guide: URL structure, content rules, database schema, and the WordPress migration history.

## Getting Started

Create `.env.local` with your Supabase credentials:

```bash
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
```

Then run the dev server:

```bash
npm install
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## Commands

```bash
npm run dev        # dev server
npm run build      # production build
npm run lint       # ESLint
npx tsc --noEmit   # typecheck
```

## Database

Supabase project `ruucexzgebbehjcrinhj` is **shared and multi-tenant** — it hosts several unrelated live sites, each keyed by `site_id`.

Of The Pitch is `ed23c093-ff1e-4355-8e4a-fd1961a03587`.

> ⚠️ Every query must filter by that `site_id`. Never run an unscoped `DELETE`,
> `TRUNCATE`, or `UPDATE` against `posts`, `pages`, `categories`, or `sites` —
> it would take another site down.

Migrations live in `supabase/migrations/`: `001_initial.sql` is the shared schema, `003_ofthepitch_migration.sql` seeds this site's content.

## URL structure

Posts and standalone pages live at the **site root** (`/<slug>`), matching the URLs WordPress served and Google indexed. Build post links with `postPath()` from `lib/utils.ts`; never hardcode the path.
