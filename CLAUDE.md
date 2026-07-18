@AGENTS.md

# Of The Pitch — Project Guide for Claude

## What This Project Is

Of The Pitch (ofthepitch.com) is an independent World Cup 2026 guide written for travelling fans. It covers visa and entry requirements by nationality, cross-border and inter-city travel, FIFA Fan Festival logistics per host city, ticket prices, how to watch matches by country and broadcaster, national squad reviews, and the tournament's controversies.

It is **not** affiliated with FIFA or any national football association.

**Stack:** Next.js 16 · Tailwind CSS 4 · Supabase (PostgreSQL)

**Supabase project ID:** `ruucexzgebbehjcrinhj` — shared, multi-tenant, hosts several unrelated live sites.

**Site slug in DB:** `ofthepitch` · **site_id:** `ed23c093-ff1e-4355-8e4a-fd1961a03587`

> ⚠️ The Supabase project is shared with other live sites. Every query must filter
> by this `site_id`. Never run an unscoped `DELETE`, `TRUNCATE`, or `UPDATE`
> against `posts`, `pages`, `categories`, or `sites` — you would take another
> site down.

---

## History: this repo was migrated from WordPress

The site ran on WordPress (Hostinger) until July 2026. Two things about that migration still matter:

**1. URLs are load-bearing.** The WordPress URLs are indexed in Google Search Console and were preserved exactly:

| What | URL shape | Route |
|---|---|---|
| Posts | `/<slug>` (site root) | `app/[slug]/page.tsx` |
| Pages | `/<slug>` (site root) | same route, falls through to `getPageBySlug` |
| Categories | `/category/<slug>` | `app/category/[slug]/page.tsx` |
| Blog listing | `/blog` | `app/blog/page.tsx` |

Posts do **not** live under `/blog/<slug>`. Always build post links with `postPath()` from `lib/utils.ts` — never hardcode the path. Changing a slug forfeits its ranking, so treat existing slugs as immutable.

**2. Most posts have no article body.** WordPress stored real prose for only 15 of 76 posts. The other 61 carried their content solely as JSON-LD, which the migration recovered:

| Tier | Count | What it has |
|---|---|---|
| Full | 15 | 1,165–1,868 words of real prose |
| FAQ | 37 | Q&A recovered from `FAQPage` schema into `faq_items` |
| Data | 24 | Squad/venue tables recovered from `SportsTeam` / `Event` schema |

The 37 FAQ and 24 data posts are thin — roughly a 30–40 word intro plus their recovered block. **Fleshing these out is the highest-value content work available.** Their titles and schema state exactly what each was meant to cover.

---

## Database Schema (Multi-tenant)

All tables have a `site_id` column. Always filter by `site_id = 'ed23c093-ff1e-4355-8e4a-fd1961a03587'`.

**posts** — title, slug, content (markdown), excerpt, quick_answer, category_id, audience_tags[], status, seo_title, seo_description, faq_items (jsonb), published_at, featured_image_url

**pages** — title, slug, content (markdown), seo_title, seo_description

**categories** — see slugs below

**Status values:** `draft` | `published`

### Categories (ofthepitch site)

Only categories that actually have posts were migrated; nine empty WordPress categories were deliberately skipped. IDs are deterministic UUID5 values — see `supabase/migrations/003_ofthepitch_migration.sql` for the literals.

| slug | posts |
|---|---|
| team-reviews | 16 |
| viewing-guides | 14 |
| controversy-and-politics | 10 |
| visa-immigration | 10 |
| fan-zone-guide | 10 |
| fan-travel-and-logistics | 6 |
| tickets-and-hospitality | 5 |
| fan-travel-logistics | 4 |
| general | 1 |

Note `fan-travel-and-logistics` and `fan-travel-logistics` are near-duplicate categories inherited from WordPress. Both are indexed, so both were kept. Merging them requires a redirect.

---

## Content Rules

### Structure
1. **Intro:** answer the reader's actual question in the first paragraph. No throat-clearing.
2. **H2 sections:** question-shaped headings where the topic suits it.
3. **Self-contained answers:** each H2's body should stand alone — that is what AI Overviews and Perplexity extract and cite.
4. **FAQ:** store Q&A in the `faq_items` jsonb column, not in the markdown body. The post template renders it and emits `FAQPage` schema automatically.
5. **Internal links:** link related guides with root-relative paths (`/some-post-slug`).

### Tone
- Practical and direct — a well-travelled friend who has actually done the border crossing.
- Concrete beats vague: name the terminal, the line, the fee, the wait time.
- Never present the site as official. It is an independent fan guide.

### Accuracy — this matters more than usual here
Ticket prices, visa wait times, broadcast rights, and fan zone dates all change. Every factual claim needs a real source (FIFA, a host-city authority, a national broadcaster). **Do not invent statistics, prices, or dates.** If a number cannot be sourced, leave it out.

---

## Brand & Design System

### Theme — "Matchday"
| Token | Hex | Use |
|---|---|---|
| primary | #0B6B3A | Pitch Green — nav, buttons, panels |
| accent | #F5A524 | Floodlight Amber — highlights, chips |
| background | #FBFAF7 | Chalk White |
| text | #12211A | Boot Black |
| muted | #5B6661 | Touchline Grey |
| success | #1E8A6E | Goal Green |
| primaryDark | #074A28 | pressed/hover on primary |
| surface | #FFFFFF | cards on the chalk base |
| line | #E6E3DB | hairline rules |

Fonts: Bricolage Grotesque (display) · Hanken Grotesk (body) · Geist Mono (meta labels).

Flat and ink-outlined — depth comes from hard offset shadows, not gradients or blurs.

---

## Key File Paths

| File | Purpose |
|---|---|
| lib/site.config.ts | Brand, theme, nav, author, feature flags — single source of site identity |
| lib/queries.ts | All Supabase data access (DO NOT write queries elsewhere) |
| lib/supabase.ts | Client setup + `getCurrentSiteId()` |
| lib/utils.ts | `postPath()` — the canonical post URL shape |
| app/[slug]/page.tsx | Post page; also resolves standalone pages |
| app/category/[slug]/page.tsx | Category archive |
| app/blog/page.tsx | Blog listing |
| components/MarkdownContent.tsx | Renders post markdown |
| public/images/ | Migrated WordPress media (yyyy/mm structure) |
| supabase/migrations/ | 001 = schema, 003 = ofthepitch content seed |

## Feature flags

`siteConfig.features.printables` is **false**, and the printables routes, components, and data layer have been removed. It was a leftover from the personal-finance template this repo was forked from.

---

## dev Commands

```bash
npm run dev        # start dev server on localhost:3000
npm run build      # production build
npm run lint       # ESLint check
npx tsc --noEmit   # typecheck
```
