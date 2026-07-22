import { NextRequest } from "next/server";
import { z } from "zod";

import { authenticate } from "@/lib/auth";
import { getCategoryById } from "@/lib/admin/data";
import {
  AdminError,
  updateCategory,
  deleteCategory,
} from "@/lib/admin/mutations";
import type { CategoryInput } from "@/lib/admin/mutations";

export const dynamic = "force-dynamic";

/**
 * Single-category REST API.
 *
 * Scoped and validated through lib/admin/mutations.ts — see the note in
 * app/api/admin/posts/[id]/route.ts. These statements previously ran as
 * `.eq("id", id)` with no site_id filter against a SHARED Supabase project.
 *
 * DELETE additionally now refuses to remove a category that still has posts,
 * rather than surfacing a raw foreign-key violation.
 */

const CategoryUpdateSchema = z.object({
  slug: z.string().min(1).optional(),
  name: z.string().min(1).optional(),
  description: z.string().nullable().optional(),
});

type CategoryPatch = z.infer<typeof CategoryUpdateSchema>;
type ExistingCategory = NonNullable<
  Awaited<ReturnType<typeof getCategoryById>>
>;

function mergeIntoInput(
  existing: ExistingCategory,
  patch: CategoryPatch
): CategoryInput {
  return {
    slug: patch.slug ?? existing.slug,
    name: patch.name ?? existing.name,
    description:
      patch.description !== undefined ? patch.description : existing.description,
  };
}

function errorResponse(err: unknown) {
  if (err instanceof AdminError) {
    return Response.json({ error: err.message }, { status: 400 });
  }
  console.error("[/api/admin/categories/[id]]", err);
  return Response.json({ error: "Internal error." }, { status: 500 });
}

export async function GET(
  request: NextRequest,
  { params }: { params: Promise<{ id: string }> }
) {
  const authError = authenticate(request);
  if (authError) return authError;

  const { id } = await params;
  const category = await getCategoryById(id);

  if (!category) {
    return Response.json({ error: "Category not found." }, { status: 404 });
  }
  return Response.json({ category });
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

  const parsed = CategoryUpdateSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json(
      { error: parsed.error.issues[0].message },
      { status: 400 }
    );
  }

  const existing = await getCategoryById(id);
  if (!existing) {
    return Response.json({ error: "Category not found." }, { status: 404 });
  }

  try {
    const category = await updateCategory(
      id,
      mergeIntoInput(existing, parsed.data)
    );
    return Response.json({ category });
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

  const existing = await getCategoryById(id);
  if (!existing) {
    return Response.json({ error: "Category not found." }, { status: 404 });
  }

  try {
    await deleteCategory(id);
    return Response.json({ deleted: true });
  } catch (err) {
    return errorResponse(err);
  }
}
