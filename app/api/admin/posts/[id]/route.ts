import { NextRequest } from "next/server";
import { z } from "zod";

import { authenticate } from "@/lib/auth";
import { getPostById } from "@/lib/admin/data";
import { AdminError, updatePost, deletePost } from "@/lib/admin/mutations";
import type { PostInput } from "@/lib/admin/mutations";

export const dynamic = "force-dynamic";

/**
 * Single-post REST API.
 *
 * Every handler resolves the row through `getPostById` (site-scoped) and writes
 * through lib/admin/mutations.ts. That matters for two things this route
 * previously got wrong:
 *
 *  1. TENANCY. The statements ran as `.eq("id", id)` with NO site_id filter.
 *     The service-role key bypasses RLS and this Supabase project is shared
 *     with other live sites, so a token holder could rewrite or delete another
 *     site's articles by guessing a UUID.
 *  2. MDX VALIDATION. Content written here skipped the compile check the
 *     dashboard performs, so this route could store body text that breaks the
 *     production build — the exact failure CLAUDE.md documents.
 *
 * Going through the shared mutation layer fixes both and keeps this route and
 * the dashboard on one code path.
 */

const FaqItemSchema = z.object({
  question: z.string().min(1),
  answer: z.string().min(1),
});

// PUT stays a PARTIAL update — every field optional, merged over the stored row.
const PostUpdateSchema = z.object({
  title: z.string().min(1).optional(),
  slug: z.string().min(1).optional(),
  content: z.string().nullable().optional(),
  excerpt: z.string().nullable().optional(),
  quick_answer: z.string().nullable().optional(),
  category_id: z.string().uuid().nullable().optional(),
  audience_tags: z.array(z.string()).optional(),
  status: z.enum(["draft", "published"]).optional(),
  seo_title: z.string().nullable().optional(),
  seo_description: z.string().nullable().optional(),
  faq_items: z.array(FaqItemSchema).optional(),
  featured_image_url: z.string().url().nullable().optional(),
  published_at: z.string().nullable().optional(),
});

type PostPatch = z.infer<typeof PostUpdateSchema>;
type ExistingPost = NonNullable<Awaited<ReturnType<typeof getPostById>>>;

/** Merge a partial patch over the stored row into a complete PostInput. */
function mergeIntoInput(existing: ExistingPost, patch: PostPatch): PostInput {
  return {
    title: patch.title ?? existing.title,
    slug: patch.slug ?? existing.slug,
    content: patch.content !== undefined ? patch.content : existing.content,
    excerpt: patch.excerpt !== undefined ? patch.excerpt : existing.excerpt,
    quick_answer:
      patch.quick_answer !== undefined
        ? patch.quick_answer
        : existing.quick_answer,
    category_id:
      patch.category_id !== undefined ? patch.category_id : existing.category_id,
    audience_tags: patch.audience_tags ?? existing.audience_tags ?? [],
    status: patch.status ?? (existing.status as "draft" | "published"),
    seo_title:
      patch.seo_title !== undefined ? patch.seo_title : existing.seo_title,
    seo_description:
      patch.seo_description !== undefined
        ? patch.seo_description
        : existing.seo_description,
    faq_items: patch.faq_items ?? existing.faq_items ?? [],
    featured_image_url:
      patch.featured_image_url !== undefined
        ? patch.featured_image_url
        : existing.featured_image_url,
    published_at:
      patch.published_at !== undefined
        ? patch.published_at
        : existing.published_at,
  };
}

function errorResponse(err: unknown) {
  // AdminError messages are written for humans and safe to return.
  if (err instanceof AdminError) {
    return Response.json({ error: err.message }, { status: 400 });
  }
  console.error("[/api/admin/posts/[id]]", err);
  return Response.json({ error: "Internal error." }, { status: 500 });
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const authError = authenticate(request);
  if (authError) return authError;

  const { id } = await params;
  const post = await getPostById(id);

  if (!post) return Response.json({ error: "Post not found." }, { status: 404 });
  return Response.json({ post });
}

export async function PUT(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const authError = authenticate(request);
  if (authError) return authError;

  const { id } = await params;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: "Invalid JSON." }, { status: 400 });
  }

  const parsed = PostUpdateSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json(
      { error: parsed.error.issues[0].message },
      { status: 400 }
    );
  }

  // Resolve scoped to this site first: another tenant's post must be
  // indistinguishable from one that doesn't exist.
  const existing = await getPostById(id);
  if (!existing) {
    return Response.json({ error: "Post not found." }, { status: 404 });
  }

  try {
    const post = await updatePost(id, mergeIntoInput(existing, parsed.data));
    return Response.json({ post });
  } catch (err) {
    return errorResponse(err);
  }
}

export async function DELETE(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const authError = authenticate(request);
  if (authError) return authError;

  const { id } = await params;

  const existing = await getPostById(id);
  if (!existing) {
    return Response.json({ error: "Post not found." }, { status: 404 });
  }

  try {
    await deletePost(id);
    return Response.json({ deleted: true });
  } catch (err) {
    return errorResponse(err);
  }
}
