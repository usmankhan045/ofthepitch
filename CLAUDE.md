@AGENTS.md

# Of The Pitch — Project Guide for Claude

## What This Project Is

Of The Pitch (www.ofthepitch.com) is an independent guide to attending sport in
person, across **horse racing, tennis, Formula 1, skiing and football**. It
covers what a venue actually enforces versus what people assume, which
enclosure or grandstand a ticket really admits you to, how to get there, and
what the day costs.

The site relaunched in September 2026 from a World Cup 2026 fan guide. The
tournament archive has been retired; see the History section below.

**Editorial position, and the reason the site can compete:** every rule is
checked against the venue's own published page, and where a venue publishes no
rule, the article says so. Retailers write dress code content because they
sell clothes, so they will never lead with "Cheltenham has no dress code" or
"Wimbledon has none for grounds admission". That gap is the whole opening.

**Revenue is outbound clicks**, mostly Pinterest into affiliate content, so
page speed and honest pin-to-page matching are commercial concerns, not just
technical ones.

It is **not** affiliated with FIFA, any governing body, venue or race organiser.

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

**2. The WordPress archive has been retired.** WordPress stored real prose for
only 15 of 76 posts; the other 61 carried their content solely as JSON-LD.

Search Console for the six months to September 2026 showed the whole archive
earning 12 clicks at an average position of 21.3, flat at zero since late
June. So it was retired rather than rewritten:

| What | Count | Status |
|---|---|---|
| Thin posts (155 to 590 chars) | 61 | `draft`, 404 |
| World Cup news posts | 10 | `draft`, each 301s to `/category/football` |
| Border-crossing and travel guides | 4 | **Published**, reframed as evergreen |

The four survivors were kept because border documents, rail routes and city
transport do not expire, and they are the only pages on the site that could
earn from the hotel and eSIM affiliates. Their titles and metadata were
reframed around the journey rather than the fixture; **their slugs were not
touched**, which is why they still read `world-cup-2026-...`.

Retiring a post means a 301 in `next.config.ts`, never a bare 404. Google
still has those URLs on file.

---

## Database Schema (Multi-tenant)

All tables have a `site_id` column. Always filter by `site_id = 'ed23c093-ff1e-4355-8e4a-fd1961a03587'`.

**posts** — title, slug, content (markdown), excerpt, quick_answer, category_id, audience_tags[], status, seo_title, seo_description, faq_items (jsonb), published_at, featured_image_url

**pages** — title, slug, content (markdown), seo_title, seo_description

**categories** — see slugs below

**Status values:** `draft` | `published`

### Categories (ofthepitch site)

Top level is the sport; subcategories sit under it via `parent_id`. A post in
a subcategory rolls up into its parent's archive, so `/category/football`
lists everything under `football-matchdays` too.

| sport | subcategories |
|---|---|
| horse-racing | racing-enclosures, racing-dress-codes, racing-racedays |
| tennis | tennis-venues, tennis-tickets, tennis-dress-codes |
| formula-1 | f1-circuits, f1-grandstands, f1-hospitality |
| skiing | ski-resorts, ski-planning |
| football | football-grounds, football-tickets, football-matchdays, world-cup-2026 |

**An empty archive is handled automatically.** `app/sitemap.ts` lists only
archives that list something, and `app/category/[slug]/page.tsx` serves
`noindex, follow` when an archive is empty. Both reverse the moment a post
lands, so a new sport's categories can be created before its content exists.

This was a real problem: 17 of 20 archives had zero posts, all returning 200
with `index, follow`, all in the sitemap.

The nine original WordPress category archives (`team-reviews`,
`viewing-guides`, `controversy-and-politics`, `visa-immigration`,
`fan-zone-guide`, `fan-travel-and-logistics`, `fan-travel-logistics`,
`tickets-and-hospitality`, `general`) are indexed and 301 to
`/category/world-cup-2026` via `next.config.ts`. **Never delete those
redirects.**

---

## Content Rules

> ⚠️ **Before writing or editing any article, read
> `content-queue/WRITING-STANDARDS.md`.** It carries 19 rules, each one
> traceable to a defect found in the first fifteen articles or the site audit
> that followed: invented prices, scraper output that was really a nav shell,
> schema images pointing at files that never existed, a cluster with zero
> internal links, SEO titles that truncated, empty category archives in the
> sitemap. The summary below is the short version; that file is the operative
> one.
>
> Validate a batch with `node scripts/validate-queue.mjs` before committing.

### Structure
1. **Intro:** answer the reader's actual question in the first paragraph. No throat-clearing.
2. **H2 sections:** question-shaped headings where the topic suits it.
3. **Self-contained answers:** each H2's body should stand alone. That is what AI Overviews and Perplexity extract and cite.
4. **FAQ:** store Q&A in the `faq_items` jsonb column, not in the markdown body. The post template renders it and emits `FAQPage` schema automatically.
5. **Internal links:** link related guides with root-relative paths (`/some-post-slug`).

### Tone
- Practical and direct, like a well-travelled friend who has actually done the border crossing.
- Concrete beats vague: name the enclosure, the gate, the fee, the wait time.
- Never present the site as official. It is an independent guide, not affiliated with any governing body, venue or race organiser.
- **No em dashes anywhere.** Full stop, comma, colon or parentheses instead. This is enforced by `scripts/validate-queue.mjs`.

### Accuracy, which matters more than usual here
Ticket prices, dress codes, opening times and dates are set by venues and change between seasons. Every factual claim needs a real source: the venue's own published page, not a secondary blog. **Do not invent statistics, prices, or dates.** If a number cannot be sourced, leave it out and say plainly that the venue does not publish it.

The counterpart rule matters just as much: **when a venue has no rule, say so.** Cheltenham, Aintree and Epsom publish no formal dress code, and Wimbledon has none for grounds admission. Retailers will never lead with that because they sell clothes. It is the site's whole editorial position.

---

## Brand & Design System

### Theme, "Enclosure"

The pitch-green "Matchday" palette was correct for a World Cup site and wrong
for one covering Ascot, Wimbledon, Monaco and Courchevel. Current tokens live
in `lib/site.config.ts` under `theme.colors` and are the single source of
truth; the values below are a reference, not a second copy to maintain.

| Token | Hex | Use |
|---|---|---|
| primary | #181512 | Ink, nav, headings, panels |
| accent | #E8A317 | Gold, headline swipe, primary button |
| accentInk | #8A5B06 | Gold darkened for type: eyebrows, links, labels |
| background | #F6F3ED | Paper, warm off-white programme stock |
| text | #181512 | Ink black, body copy |
| muted | #6E6558 | Paddock grey, secondary copy |
| success | #2F8F5B | Turf green |
| surface | #FFFFFF | Cards on the paper base |
| line | #E1DACD | Hairline rules |

One colour per sport, in `theme.sports`, so a reader identifies a sport before
reading the label: horse racing #CF5A2E, tennis #2F8F5B, Formula 1 #D22C1F,
skiing #2A87B4, football #7458C9. Post cards, chips and category rules all
take their hue from there.

Fonts: Bricolage Grotesque (display), Hanken Grotesk (body), Geist Mono (meta
labels).

Flat and ink-outlined. Depth comes from hard offset shadows, not gradients or
blurs. Animation follows the Emil Kowalski rules in `app/globals.css`: custom
easing, sub-300ms durations, transitions over keyframes, hover gated behind
`@media (hover:hover)`.

### Canonical host

`siteConfig.domain` is **`www.ofthepitch.com`**. The apex 308-redirects to it.
That one string builds every canonical tag, OG image URL, sitemap entry and
schema id, so pointing it at the apex means OG images never render for
scrapers that do not follow redirects. Verify with
`curl -sI https://ofthepitch.com/blog` before changing it.

### Generated assets

Post preview cards are generated by `/api/og` from the title, category and
sport colour. **Never set `featured_image_url` on a new post.** Meta tags use
1200x630; on-site cards pass `ratio=card` for 1200x750, because the card slot
is 16:10 and cropping a 1.91:1 image into it cut the first character off every
title.

`llms.txt` is generated from the live category tree at `app/llms.txt/route.ts`,
not a static file. The previous static version survived the relaunch telling AI
crawlers this was a World Cup site.

## Key File Paths

| File | Purpose |
|---|---|
| **content-queue/WRITING-STANDARDS.md** | **19 rules every article must follow. Read before writing.** |
| content-queue/README.md | How the drip publisher works |
| content-queue/schedule.json | slug to publish time |
| content-queue/articles/ | One JSON payload per queued article |
| scripts/validate-queue.mjs | Enforces the mechanical half of the standards |
| scripts/publish-due-posts.mjs | Publishes what is due, idempotent |
| .github/workflows/publish-scheduled-posts.yml | Runs the publisher every 30 min |
| lib/site.config.ts | Brand, theme, nav, author, feature flags. Single source of site identity |
| lib/queries.ts | All Supabase data access (DO NOT write queries elsewhere) |
| lib/schema.ts | JSON-LD graph. Image URLs must resolve; three once 404'd |
| lib/metadata.ts | OG/Twitter image helpers |
| lib/admin/preview-image.ts | Resolves a post's card URL, `og` or `card` ratio |
| lib/supabase.ts | Client setup + `getCurrentSiteId()` |
| lib/utils.ts | `postPath()`, the canonical post URL shape, and `sportForCategory()` |
| app/api/og/route.tsx | Generates every post card |
| app/llms.txt/route.ts | Generated llms.txt, not static |
| app/sitemap.ts | Excludes empty archives |
| app/[slug]/page.tsx | Post page; also resolves standalone pages |
| app/category/[slug]/page.tsx | Category archive; noindexes when empty |
| app/blog/page.tsx | Blog listing |
| components/MarkdownContent.tsx | Renders markdown; unlinks unpublished targets |
| components/PostCard.tsx | Post card; requests the 16:10 card ratio |
| next.config.ts | Redirects for every retired post and archive |
| public/images/ | Migrated WordPress media (yyyy/mm structure) |
| supabase/migrations/ | 001 = schema, 003 = ofthepitch content seed, 005 = printables |

## Feature flags

`siteConfig.features.printables` is **true**. Printables are free downloads for
travelling fans — visa document checklists, matchday packing lists, city planners.

They were stripped during the WordPress migration as a personal-finance-template
leftover, then deliberately re-introduced for this site. The implementation was
recovered from the pre-squash history (`a8ec3ae`, the SpendWiseCents baseline)
rather than rewritten, so the callout and preview match the original design.

| Piece | Where |
|---|---|
| Public listing / detail | `/printables`, `/printables/<slug>` |
| Admin CRUD + upload | `/admin/printables` |
| Attach to a post | Post editor sidebar → renders callouts after the article |
| Mention inline | `{{printable:slug}}` in the body → callout at that exact point |

Two things to know before editing:

1. **Shortcode order is load-bearing.** `expandShortcodes()` in
   `components/MarkdownContent.tsx` must expand `{{printable:slug}}` *before* the
   catch-all `{{...}}` strip. Reversing them silently deletes every mention — that
   is exactly what happened during the migration.
2. **Migration 005** (`supabase/migrations/005_printables.sql`) adds the
   `post_printables` join table. Without it, attaching is unavailable but
   everything else — listing, detail pages, inline mentions — still works.

---

## Pinterest

`docs/PINTEREST-STRATEGY.md` carries the keyword data, the design concept and
the platform rules. Pulled from Pinterest's own `/ideas/` pages, which publish
search volume as "N people searched this".

Three findings that contradict the obvious approach:

- **Formula 1 outfit is 20k, the largest single term found**, larger than any
  racing term. F1 moves ahead of tennis in the content order.
- **Menswear is measured dead.** "Cheltenham races mens fashion" returns 21
  searches against 4k for the women's equivalent. Write for women first.
- **Light grounds win and brand palettes lose.** 87 of the top 100 viral pin
  colours were white or near-white, and only 4% of designed viral pins used a
  brand palette. **Pins are a separate design system from the site's dark ink
  article cards. Never reuse the OG card design as a pin.**

## Content pipeline

Articles are written in batches as files in `content-queue/`, not as rows in
the `posts` table, and a GitHub Actions cron publishes each one when its
scheduled date arrives. See `content-queue/README.md` for how the publisher
works and `content-queue/WRITING-STANDARDS.md` for what an article must
contain.

Two things to know before touching a published article:

1. **Edit both** the queue file and the database row. The publisher will not
   overwrite a post that already exists.
2. **Never change a published slug.** It forfeits whatever the URL has earned.
   Everything else about an article can be reframed; the slug cannot.

## dev Commands

```bash
npm run dev        # start dev server on localhost:3000
npm run build      # production build
npm run lint       # ESLint check
npx tsc --noEmit   # typecheck

node scripts/validate-queue.mjs          # check the content queue
DRY_RUN=1 node scripts/publish-due-posts.mjs   # what would publish, writes nothing
```
