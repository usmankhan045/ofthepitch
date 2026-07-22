import { NextRequest } from "next/server";
import { z } from "zod";
import { authenticate } from "@/lib/auth";
import { getSupabaseAdmin, getCurrentSiteId } from "@/lib/supabase";
import { AdminError, createPost } from "@/lib/admin/mutations";

export const dynamic = "force-dynamic";

const FaqItemSchema = z.object({
  question: z.string().min(1),
  answer: z.string().min(1),
});

// NOTE: `site_id` is deliberately NOT accepted from the caller. It used to be,
// which let a token holder insert rows into another tenant of this shared
// Supabase project. The site is always resolved server-side.
const PostCreateSchema = z.object({
  title: z.string().min(1, "title is required"),
  slug: z.string().min(1, "slug is required"),
  content: z.string().optional(),
  excerpt: z.string().optional(),
  quick_answer: z.string().optional(),
  category_id: z.string().uuid().nullable().optional(),
  audience_tags: z.array(z.string()).default([]),
  status: z.enum(["draft", "published"]).default("draft"),
  seo_title: z.string().optional(),
  seo_description: z.string().optional(),
  faq_items: z.array(FaqItemSchema).default([]),
  featured_image_url: z.string().url().nullable().optional(),
  published_at: z.string().nullable().optional(),
});

export async function GET(request: NextRequest) {
  const authError = authenticate(request);
  if (authError) return authError;

  const sp = request.nextUrl.searchParams;
  // Always this site — a caller-supplied site_id would expose other tenants.
  const siteId = await getCurrentSiteId();
  const status = sp.get("status");
  const categoryId = sp.get("category");
  const audienceTag = sp.get("audience_tag");

  let query = getSupabaseAdmin()
    .from("posts")
    .select("*, categories(slug, name)")
    .eq("site_id", siteId)
    .order("created_at", { ascending: false });

  if (status) query = query.eq("status", status);
  if (categoryId) query = query.eq("category_id", categoryId);
  if (audienceTag) query = query.contains("audience_tags", [audienceTag]);

  const { data, error } = await query;
  if (error) {
    console.error("[GET /api/admin/posts]", error);
    return Response.json({ error: "Could not load posts." }, { status: 500 });
  }

  return Response.json({ posts: data });
}

export async function POST(request: NextRequest) {
  const authError = authenticate(request);
  if (authError) return authError;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: "Invalid JSON." }, { status: 400 });
  }

  const parsed = PostCreateSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json(
      { error: parsed.error.issues[0].message },
      { status: 400 }
    );
  }

  // Write through the shared mutation layer: it scopes to this site, compiles
  // the MDX before storing it, enforces slug rules and revalidates. Writing
  // directly here previously bypassed all four.
  try {
    const post = await createPost(parsed.data);
    return Response.json({ post }, { status: 201 });
  } catch (err) {
    if (err instanceof AdminError) {
      return Response.json({ error: err.message }, { status: 400 });
    }
    console.error("[POST /api/admin/posts]", err);
    return Response.json({ error: "Internal error." }, { status: 500 });
  }
}
