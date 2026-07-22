import { NextRequest } from "next/server";
import { z } from "zod";

import { authenticate } from "@/lib/auth";
import { getPageById } from "@/lib/admin/data";
import { AdminError, updatePage, deletePage } from "@/lib/admin/mutations";
import type { PageInput } from "@/lib/admin/mutations";

export const dynamic = "force-dynamic";

/**
 * Single-page REST API.
 *
 * Scoped and validated through lib/admin/mutations.ts — see the note in
 * app/api/admin/posts/[id]/route.ts. These statements previously ran as
 * `.eq("id", id)` with no site_id filter against a SHARED Supabase project,
 * and skipped MDX compile-checking on `content`.
 */

const PageUpdateSchema = z.object({
  slug: z.string().min(1).optional(),
  title: z.string().nullable().optional(),
  content: z.string().nullable().optional(),
  seo_title: z.string().nullable().optional(),
  seo_description: z.string().nullable().optional(),
});

type PagePatch = z.infer<typeof PageUpdateSchema>;
type ExistingPage = NonNullable<Awaited<ReturnType<typeof getPageById>>>;

function mergeIntoInput(existing: ExistingPage, patch: PagePatch): PageInput {
  return {
    slug: patch.slug ?? existing.slug,
    title: patch.title !== undefined ? patch.title : existing.title,
    content: patch.content !== undefined ? patch.content : existing.content,
    seo_title:
      patch.seo_title !== undefined ? patch.seo_title : existing.seo_title,
    seo_description:
      patch.seo_description !== undefined
        ? patch.seo_description
        : existing.seo_description,
  };
}

function errorResponse(err: unknown) {
  if (err instanceof AdminError) {
    return Response.json({ error: err.message }, { status: 400 });
  }
  console.error("[/api/admin/pages/[id]]", err);
  return Response.json({ error: "Internal error." }, { status: 500 });
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const authError = authenticate(request);
  if (authError) return authError;

  const { id } = await params;
  const page = await getPageById(id);

  if (!page) return Response.json({ error: "Page not found." }, { status: 404 });
  return Response.json({ page });
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

  const parsed = PageUpdateSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json(
      { error: parsed.error.issues[0].message },
      { status: 400 }
    );
  }

  const existing = await getPageById(id);
  if (!existing) {
    return Response.json({ error: "Page not found." }, { status: 404 });
  }

  try {
    const page = await updatePage(id, mergeIntoInput(existing, parsed.data));
    return Response.json({ page });
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

  const existing = await getPageById(id);
  if (!existing) {
    return Response.json({ error: "Page not found." }, { status: 404 });
  }

  try {
    await deletePage(id);
    return Response.json({ deleted: true });
  } catch (err) {
    return errorResponse(err);
  }
}
