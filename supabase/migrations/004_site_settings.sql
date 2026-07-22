-- ─────────────────────────────────────────────────────────────────────────────
-- 004: site_settings
--
-- Runtime-editable site identity for the admin dashboard: brand strings, theme
-- colours, nav and footer links, social handles.
--
-- ⚠️ This Supabase project is SHARED with several other live sites. Every
-- statement below is scoped to a single site_id. Do not run an unscoped
-- UPDATE/DELETE against this or any other table here.
--
-- Design note: this table stores OVERRIDES only. lib/site.config.ts remains the
-- source of defaults, and lib/settings.ts merges DB values over it. That means:
--   * the site still boots correctly if this table is missing or empty
--     (important — it is created after the app was already deployed), and
--   * anything not overridden stays in git, where it is reviewable and
--     revertible.
-- Tenancy fields (slug, site_id, domain) are deliberately NOT stored here —
-- they must not be editable from a dashboard.
-- ─────────────────────────────────────────────────────────────────────────────

create table if not exists site_settings (
  site_id      uuid primary key references sites(id) on delete cascade,

  -- Brand strings. NULL means "use the value from site.config.ts".
  name         text,
  tagline      text,

  -- jsonb so the shape can evolve without a migration per field.
  -- theme_colors: { primary, accent, background, text, muted, success,
  --                 primaryDark, surface, line }
  theme_colors jsonb,
  -- nav / footer_links: [{ "label": "...", "href": "/..." }]
  nav          jsonb,
  footer_links jsonb,
  -- social: { pinterest?, x?, instagram? }
  social       jsonb,

  contact_email text,

  updated_at   timestamptz default now()
);

comment on table site_settings is
  'Per-site overrides for lib/site.config.ts defaults. Nullable columns fall back to code.';

-- Seed an empty row for ofthepitch so the dashboard has something to update.
-- ON CONFLICT DO NOTHING keeps this migration safe to re-run and guarantees it
-- never clobbers settings an admin has already saved.
insert into site_settings (site_id)
values ('ed23c093-ff1e-4355-8e4a-fd1961a03587')
on conflict (site_id) do nothing;
