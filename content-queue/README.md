# Content queue — scheduled auto-publishing

This directory drives a **drip-publisher**: queued articles are inserted into
Supabase automatically on their scheduled date, so content rolls out gradually
instead of all at once.

It follows the same pattern as the publisher on spendwisecents, deliberately.

## How it works

- **`schedule.json`** — maps every `slug` → its scheduled publish time (ISO UTC).
- **`articles/<slug>.json`** — the full post payload for each slug
  (`title, excerpt, quick_answer, content, seo_title, seo_description,
  audience_tags, faq_items, category`).
- **`../scripts/publish-due-posts.mjs`** — publishes every article whose scheduled
  time has passed and that is **not already in the database**.
- **`../.github/workflows/publish-scheduled-posts.yml`** — runs the script every
  30 minutes via GitHub Actions.

The publisher is **idempotent**: the database is the source of truth for what is
already live, so re-runs, delayed runs and overlapping runs never double-post.
If GitHub skips or delays a cron tick (it is best-effort), the next run catches up.

### Why the queue lives in files, not as `scheduled` rows

An earlier version of this stored articles in the `posts` table with
`status = 'scheduled'` and flipped them to `published` on the day. Three reasons
this is better:

1. An article is reviewable in a diff before it can ever go live.
2. Nothing half-written sits in the `posts` table waiting on a status flip, so a
   bug in the publisher cannot expose a draft.
3. "Already in the DB" is a safer due-check than "status = scheduled", because it
   survives someone editing a post by hand in the admin.

### Why the cron runs every 30 minutes

GitHub's scheduler is best-effort and often runs late. A once-a-day tick aimed at
the exact publish minute can miss, leaving a post waiting a full extra day. A
frequent tick means a delayed run simply catches up.

## Activation (one-time)

Add repository secrets — GitHub → Settings → Secrets and variables → Actions:

| Secret | Required | Value |
|---|---|---|
| `SUPABASE_URL` | yes | Supabase project URL (same as `.env.local`) |
| `SUPABASE_SERVICE_ROLE_KEY` | yes | service-role key (same as `.env.local`) |
| `SITE_BASE_URL` | no | e.g. `https://ofthepitch.com`, to refresh the live site |
| `REVALIDATION_SECRET` | no | same as `.env.local`, pairs with the above |

Without the last two the post still publishes; the site picks it up on the next
deploy or cache expiry instead of immediately.

## Test without publishing

GitHub → Actions → *Publish scheduled posts* → **Run workflow** → check
**dry_run** → Run. It logs what *would* publish and inserts nothing.

Locally:

```bash
set -a && . ./.env.local && set +a
DRY_RUN=1 node scripts/publish-due-posts.mjs
```

## Adding posts

Drop a new `articles/<slug>.json` and add the slug to `schedule.json`. The next
run picks it up when its time arrives. A slug present in `articles/` but missing
from `schedule.json` is skipped and logged.

## Notes

- Posts publish with `status: "published"` and `published_at` set to the
  scheduled time.
- `featured_image_url` is left NULL on purpose. The post page falls back to a
  generated card from `/api/og`, and the admin's "missing image" count stays
  truthful.
- `MAX_PER_RUN` (default 12) caps inserts per run, so a bad schedule cannot dump
  the whole queue at once.
