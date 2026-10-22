-- Per-post accessibility/social metadata and CMS scheduling.
-- The application uses the service-role key on the server; no new client-side
-- grants or policies are needed for these columns.
alter table public.posts
  add column if not exists featured_image_alt text,
  add column if not exists publish_at timestamptz;

create index if not exists idx_posts_scheduled_due
  on public.posts (site_id, publish_at)
  where status = 'scheduled';

comment on column public.posts.featured_image_alt is
  'Human-written alt text for the featured image and og:image:alt.';
comment on column public.posts.publish_at is
  'When a scheduled post should be changed to published; null for drafts/live posts.';
