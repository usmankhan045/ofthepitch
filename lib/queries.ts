/**
 * Data-access layer — the only place raw Supabase queries should be written.
 * Every function filters by site_id via getCurrentSiteId() to enforce
 * multi-tenant isolation. Never bypass this by writing queries elsewhere.
 */
import { supabaseAdmin, getCurrentSiteId } from "./supabase";

// ── Type definitions ─────────────────────────────────────────────────────────

export interface Post {
  id: string;
  slug: string;
  title: string;
  excerpt: string | null;
  content: string | null;
  quick_answer: string | null;
  featured_image_url: string | null;
  category_id: string | null;
  audience_tags: string[];
  status: string;
  seo_title: string | null;
  seo_description: string | null;
  faq_items: FaqItem[];
  published_at: string | null;
  created_at: string;
  updated_at: string;
  categories?: { slug: string; name: string } | null;
}

export interface Category {
  id: string;
  slug: string;
  name: string;
  description: string | null;
  /** Null for a top-level sport; set for a subcategory beneath one. */
  parent_id: string | null;
}

/** A top-level sport with the subcategories filed under it. */
export interface CategoryTree extends Category {
  postCount: number;
  children: Array<Category & { postCount: number }>;
}

export interface Page {
  id: string;
  slug: string;
  title: string | null;
  content: string | null;
  seo_title: string | null;
  seo_description: string | null;
  updated_at: string;
}

export interface FaqItem {
  question: string;
  answer: string;
}

// ── Posts ────────────────────────────────────────────────────────────────────

export async function getPublishedPosts(options?: {
  limit?: number;
  offset?: number;
  categoryId?: string;
  /** Several categories at once, used by a parent archive to include its children. */
  categoryIds?: string[];
  audienceTag?: string;
  search?: string;
}): Promise<Post[]> {
  const siteId = await getCurrentSiteId();

  let query = supabaseAdmin
    .from("posts")
    .select("*, categories(slug, name)")
    .eq("site_id", siteId)
    .eq("status", "published")
    .not("published_at", "is", null)
    .order("published_at", { ascending: false });

  if (options?.categoryIds?.length) {
    query = query.in("category_id", options.categoryIds);
  } else if (options?.categoryId) {
    query = query.eq("category_id", options.categoryId);
  }

  if (options?.audienceTag) {
    query = query.contains("audience_tags", [options.audienceTag]);
  }

  if (options?.search) {
    // Simple text match across title + excerpt. Escape %,_ and commas (commas
    // break PostgREST's .or() list syntax).
    const term = options.search.replace(/[%_,]/g, " ").trim();
    if (term) {
      query = query.or(`title.ilike.%${term}%,excerpt.ilike.%${term}%`);
    }
  }

  if (options?.limit) query = query.limit(options.limit);
  if (options?.offset) query = query.range(options.offset, (options.offset + (options.limit ?? 10)) - 1);

  const { data, error } = await query;
  if (error) throw error;
  return (data ?? []) as Post[];
}

export async function getPostBySlug(slug: string): Promise<Post | null> {
  const siteId = await getCurrentSiteId();

  const { data, error } = await supabaseAdmin
    .from("posts")
    .select("*, categories(slug, name)")
    .eq("site_id", siteId)
    .eq("slug", slug)
    .eq("status", "published")
    .single();

  if (error?.code === "PGRST116") return null; // not found
  if (error) throw error;
  return data as Post;
}

export async function getPostsByAudienceTag(tag: string, limit = 10): Promise<Post[]> {
  return getPublishedPosts({ audienceTag: tag, limit });
}

// ── Categories ───────────────────────────────────────────────────────────────

export async function getCategories(): Promise<Category[]> {
  const siteId = await getCurrentSiteId();

  const { data, error } = await supabaseAdmin
    .from("categories")
    .select("*")
    .eq("site_id", siteId)
    .order("name");

  if (error) throw error;
  return (data ?? []) as Category[];
}

/**
 * Categories that have at least one published post, with their post counts.
 * Used to drive the navbar "Categories" dropdown — empty categories are hidden.
 */
export async function getCategoriesWithPostCounts(): Promise<
  Array<Category & { postCount: number }>
> {
  const siteId = await getCurrentSiteId();

  const [categories, postsRes] = await Promise.all([
    getCategories(),
    supabaseAdmin
      .from("posts")
      .select("category_id")
      .eq("site_id", siteId)
      .eq("status", "published")
      .not("published_at", "is", null),
  ]);

  if (postsRes.error) throw postsRes.error;

  const counts = new Map<string, number>();
  for (const row of postsRes.data ?? []) {
    const id = (row as { category_id: string | null }).category_id;
    if (id) counts.set(id, (counts.get(id) ?? 0) + 1);
  }

  // A parent's count rolls up its children, so Football reports every post
  // filed under its subcategories rather than the zero posts filed directly.
  const withOwn = categories.map((c) => ({ ...c, postCount: counts.get(c.id) ?? 0 }));

  return withOwn
    .map((c) => {
      if (c.parent_id) return c;
      const rolled = withOwn
        .filter((child) => child.parent_id === c.id)
        .reduce((sum, child) => sum + child.postCount, c.postCount);
      return { ...c, postCount: rolled };
    })
    .filter((c) => c.postCount > 0);
}

/**
 * The full category tree: top-level sports, each with its subcategories.
 * Drives the navigation mega menu and the homepage sport picker. Sports with
 * no posts anywhere beneath them are kept, so a new sport still appears in the
 * navigation before its first guide is published.
 */
export async function getCategoryTree(): Promise<CategoryTree[]> {
  const siteId = await getCurrentSiteId();

  const [categories, postsRes] = await Promise.all([
    getCategories(),
    supabaseAdmin
      .from("posts")
      .select("category_id")
      .eq("site_id", siteId)
      .eq("status", "published")
      .not("published_at", "is", null),
  ]);

  if (postsRes.error) throw postsRes.error;

  const counts = new Map<string, number>();
  for (const row of postsRes.data ?? []) {
    const id = (row as { category_id: string | null }).category_id;
    if (id) counts.set(id, (counts.get(id) ?? 0) + 1);
  }

  const withOwn = categories.map((c) => ({ ...c, postCount: counts.get(c.id) ?? 0 }));

  return withOwn
    .filter((c) => !c.parent_id)
    .map((parent) => {
      const children = withOwn
        .filter((c) => c.parent_id === parent.id)
        .sort((a, b) => b.postCount - a.postCount || a.name.localeCompare(b.name));
      return {
        ...parent,
        postCount: children.reduce((sum, c) => sum + c.postCount, parent.postCount),
        children,
      };
    });
}

export async function getCategoryBySlug(slug: string): Promise<Category | null> {
  const siteId = await getCurrentSiteId();

  const { data, error } = await supabaseAdmin
    .from("categories")
    .select("*")
    .eq("site_id", siteId)
    .eq("slug", slug)
    .single();

  if (error?.code === "PGRST116") return null;
  if (error) throw error;
  return data as Category;
}

export async function getPostsByCategory(categorySlug: string, limit = 20): Promise<Post[]> {
  const category = await getCategoryBySlug(categorySlug);
  if (!category) return [];

  // A sport archive lists everything filed under its subcategories as well as
  // anything filed directly against it. Without this, /category/football is
  // empty because every post sits in one of its children.
  const all = await getCategories();
  const childIds = all.filter((c) => c.parent_id === category.id).map((c) => c.id);

  if (childIds.length > 0) {
    return getPublishedPosts({ categoryIds: [category.id, ...childIds], limit });
  }
  return getPublishedPosts({ categoryId: category.id, limit });
}


// ── Pages ────────────────────────────────────────────────────────────────────

export async function getPageBySlug(slug: string): Promise<Page | null> {
  const siteId = await getCurrentSiteId();

  const { data, error } = await supabaseAdmin
    .from("pages")
    .select("*")
    .eq("site_id", siteId)
    .eq("slug", slug)
    .single();

  if (error?.code === "PGRST116") return null;
  if (error) throw error;
  return data as Page;
}

// ── Subscribers ──────────────────────────────────────────────────────────────

export async function addSubscriber(email: string, source?: string): Promise<void> {
  const siteId = await getCurrentSiteId();

  const { error } = await supabaseAdmin
    .from("subscribers")
    .insert({ site_id: siteId, email, source });

  // Silently ignore duplicate emails
  if (error && !error.message.includes("duplicate")) throw error;
}

// ── Contact messages ─────────────────────────────────────────────────────────

export async function saveContactMessage(params: {
  name: string;
  email: string;
  message: string;
}): Promise<void> {
  const siteId = await getCurrentSiteId();

  const { error } = await supabaseAdmin
    .from("contact_messages")
    .insert({ site_id: siteId, ...params });

  if (error) throw error;
}

// ── Pagination helpers ────────────────────────────────────────────────────────

export async function getPublishedPostCount(options?: {
  categoryId?: string;
  categoryIds?: string[];
  audienceTag?: string;
}): Promise<number> {
  const siteId = await getCurrentSiteId();

  let query = supabaseAdmin
    .from("posts")
    .select("*", { count: "exact", head: true })
    .eq("site_id", siteId)
    .eq("status", "published")
    .not("published_at", "is", null);

  if (options?.categoryIds?.length) {
    query = query.in("category_id", options.categoryIds);
  } else if (options?.categoryId) {
    query = query.eq("category_id", options.categoryId);
  }

  if (options?.audienceTag) {
    query = query.contains("audience_tags", [options.audienceTag]);
  }

  const { count, error } = await query;
  if (error) throw error;
  return count ?? 0;
}

// ── Related posts ─────────────────────────────────────────────────────────────

export async function getRelatedPosts(params: {
  categoryId: string | null;
  audienceTags: string[];
  excludeSlug: string;
  limit?: number;
}): Promise<Post[]> {
  const siteId = await getCurrentSiteId();
  const limit = params.limit ?? 3;
  const seen = new Set<string>();
  const results: Post[] = [];

  const makeBase = () =>
    supabaseAdmin
      .from("posts")
      .select("*, categories(slug, name)")
      .eq("site_id", siteId)
      .eq("status", "published")
      .not("published_at", "is", null)
      .neq("slug", params.excludeSlug)
      .order("published_at", { ascending: false });

  if (params.categoryId) {
    const { data } = await makeBase()
      .eq("category_id", params.categoryId)
      .limit(limit);
    for (const p of (data ?? []) as Post[]) {
      if (!seen.has(p.slug)) { seen.add(p.slug); results.push(p); }
    }
  }

  for (const tag of params.audienceTags) {
    if (results.length >= limit) break;
    const { data } = await makeBase()
      .contains("audience_tags", [tag])
      .limit(limit);
    for (const p of (data ?? []) as Post[]) {
      if (!seen.has(p.slug) && results.length < limit) {
        seen.add(p.slug);
        results.push(p);
      }
    }
  }

  return results.slice(0, limit);
}

// ── Printables ───────────────────────────────────────────────────────────────

/**
 * Log a given warning only once per process.
 *
 * A production build renders all 76 posts, so a per-post console.error about a
 * missing table produces 76 identical lines and buries anything real.
 */
const warned = new Set<string>();
function warnOnce(key: string, message: string): void {
  if (warned.has(key)) return;
  warned.add(key);
  console.warn(message);
}

export interface Printable {
  id: string;
  slug: string;
  title: string;
  description: string | null;
  file_url: string | null;
  thumbnail_url: string | null;
  category_id: string | null;
  /** Drives the aspect ratio of the on-page preview. */
  orientation: "portrait" | "landscape";
  created_at: string;
  updated_at: string | null;
  categories?: { slug: string; name: string } | null;
}

export async function getPrintables(categoryId?: string): Promise<Printable[]> {
  const siteId = await getCurrentSiteId();

  let query = supabaseAdmin
    .from("printables")
    .select("*, categories(slug, name)")
    .eq("site_id", siteId)
    .order("created_at", { ascending: false });

  if (categoryId) query = query.eq("category_id", categoryId);

  const { data, error } = await query;
  if (error) throw error;
  return (data ?? []) as Printable[];
}

export async function getPrintableBySlug(slug: string): Promise<Printable | null> {
  const siteId = await getCurrentSiteId();

  const { data, error } = await supabaseAdmin
    .from("printables")
    .select("*, categories(slug, name)")
    .eq("site_id", siteId)
    .eq("slug", slug)
    .maybeSingle();

  if (error) throw error;
  return (data as Printable) ?? null;
}

/**
 * Printables attached to a post, in the admin's chosen order.
 *
 * Returns [] rather than throwing when the join table is missing (migration 005
 * not yet applied) — a post page must still render without its downloads.
 */
export async function getPrintablesForPost(postId: string): Promise<Printable[]> {
  const siteId = await getCurrentSiteId();

  const { data, error } = await supabaseAdmin
    .from("post_printables")
    .select("sort_order, printables(*, categories(slug, name))")
    .eq("post_id", postId)
    .order("sort_order", { ascending: true });

  if (error) {
    // Warn once per process. A build renders every post, and 76 copies of the
    // same "table is missing" line would bury any genuine error in the output.
    warnOnce("post_printables", `[getPrintablesForPost] ${error.message}`);
    return [];
  }

  return ((data ?? []) as unknown as Array<{ printables: Printable | null }>)
    .map((row) => row.printables)
    // The join filters only on post_id; scope the resolved printables to this
    // site too, so a stray cross-tenant link can never surface another site's
    // download on our page. `printables(*)` includes site_id.
    .filter(
      (p): p is Printable =>
        Boolean(p) && (p as { site_id?: string }).site_id === siteId
    );
}

/** Posts that feature a given printable — powers "used in" on its detail page. */
export async function getPostsForPrintable(
  printableId: string,
  limit = 6
): Promise<Array<Pick<Post, "id" | "title" | "slug">>> {
  const siteId = await getCurrentSiteId();

  const { data, error } = await supabaseAdmin
    .from("post_printables")
    .select("posts(id, title, slug, status, site_id)")
    .eq("printable_id", printableId)
    .limit(limit);

  if (error) {
    warnOnce("post_printables", `[getPostsForPrintable] ${error.message}`);
    return [];
  }

  return ((data ?? []) as unknown as Array<{
    posts: (Pick<Post, "id" | "title" | "slug"> & {
      status: string;
      site_id: string;
    }) | null;
  }>)
    .map((row) => row.posts)
    // Only ever surface live posts belonging to this site.
    .filter(
      (p): p is Pick<Post, "id" | "title" | "slug"> & {
        status: string;
        site_id: string;
      } => Boolean(p) && p!.status === "published" && p!.site_id === siteId
    )
    .map(({ id, title, slug }) => ({ id, title, slug }));
}

/**
 * Printables referenced by `{{printable:slug}}` in a post body.
 *
 * An inline mention doesn't require attaching the printable to the post, so
 * these have to be resolved from the body text — otherwise every un-attached
 * mention would render with generic placeholder copy instead of its real title.
 */
export async function getPrintablesMentionedIn(
  content: string | null | undefined
): Promise<Printable[]> {
  if (!content) return [];

  const slugs = Array.from(
    new Set(
      Array.from(content.matchAll(/\{\{printable:\s*([a-z0-9-]+)\s*\}\}/gi)).map(
        (m) => m[1].toLowerCase()
      )
    )
  );

  if (slugs.length === 0) return [];

  const siteId = await getCurrentSiteId();

  const { data, error } = await supabaseAdmin
    .from("printables")
    .select("*, categories(slug, name)")
    .eq("site_id", siteId)
    .in("slug", slugs);

  if (error) {
    warnOnce("printables-mentioned", `[getPrintablesMentionedIn] ${error.message}`);
    return [];
  }

  return (data ?? []) as Printable[];
}

/**
 * Which of the given slugs are published on this site.
 *
 * Used to drop links to articles that are queued but not live yet: the
 * content queue cross-links a whole cluster, while the drip publisher brings
 * those articles online days apart.
 */
export async function getPublishedSlugs(slugs: string[]): Promise<Set<string>> {
  if (slugs.length === 0) return new Set();
  const siteId = await getCurrentSiteId();
  const { data, error } = await supabaseAdmin
    .from("posts")
    .select("slug")
    .eq("site_id", siteId)
    .eq("status", "published")
    .not("published_at", "is", null)
    .in("slug", slugs);

  if (error) {
    // A failed lookup must not strip every link; assume they are fine.
    console.error("[getPublishedSlugs]", error.message);
    return new Set(slugs);
  }
  return new Set((data ?? []).map((r: { slug: string }) => r.slug));
}
