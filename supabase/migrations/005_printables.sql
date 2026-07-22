-- ─────────────────────────────────────────────────────────────────────────────
-- 005: printables for ofthepitch
--
-- The `printables` table itself already exists from 001_initial.sql — it was
-- created for every site in this project and simply left empty for ofthepitch.
-- This migration adds the two things the feature actually needs:
--
--   1. `orientation` on printables. The upstream template's TypeScript type
--      declared this field but 001 never created the column, so every read
--      silently returned undefined. Adding it for real fixes that latent bug
--      and lets the preview size a landscape sheet correctly.
--   2. `post_printables` — the many-to-many join so a post can attach several
--      printables and one printable can appear on several posts.
--
-- ⚠️ This Supabase project is SHARED with other live sites. `printables` is a
-- shared table: the ALTER below is additive and nullable-with-default, so it
-- cannot break another tenant's rows. Do not run an unscoped UPDATE or DELETE.
-- ─────────────────────────────────────────────────────────────────────────────

-- ── 1. orientation ───────────────────────────────────────────────────────────
alter table printables
  add column if not exists orientation text not null default 'portrait';

alter table printables
  drop constraint if exists printables_orientation_check;

alter table printables
  add constraint printables_orientation_check
  check (orientation in ('portrait', 'landscape'));

-- updated_at, maintained by a trigger rather than the application.
--
-- Deliberately NOT written from app code: the column does not exist until this
-- migration runs, and an INSERT naming a missing column fails outright
-- (PGRST204). A trigger means the same code path works before and after.
alter table printables
  add column if not exists updated_at timestamptz default now();

create or replace function set_printables_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_printables_updated_at on printables;

create trigger trg_printables_updated_at
  before update on printables
  for each row
  execute function set_printables_updated_at();

comment on column printables.orientation is
  'Page orientation, drives the aspect ratio of the on-page preview.';

-- ── 2. post ↔ printable join ─────────────────────────────────────────────────
create table if not exists post_printables (
  post_id      uuid not null references posts(id) on delete cascade,
  printable_id uuid not null references printables(id) on delete cascade,

  -- Explicit ordering so the admin controls which download leads.
  sort_order   integer not null default 0,
  created_at   timestamptz default now(),

  primary key (post_id, printable_id)
);

-- The common read is "printables for this post", ordered.
create index if not exists idx_post_printables_post
  on post_printables (post_id, sort_order);

-- The reverse read powers "which posts feature this printable".
create index if not exists idx_post_printables_printable
  on post_printables (printable_id);

comment on table post_printables is
  'Many-to-many: posts reference printables. ON DELETE CASCADE on both sides, so removing either end cleans up the link rather than orphaning it.';

-- Note: there is deliberately no site_id column here. Both sides already
-- reference rows that carry one, and the application always resolves the post
-- or printable (which IS site-scoped) before touching this table.
