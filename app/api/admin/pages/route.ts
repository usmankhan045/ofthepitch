import { NextRequest } from "next/server";
import { z } from "zod";
import { authenticate } from "@/lib/auth";
import { getSupabaseAdmin, getCurrentSiteId } from "@/lib/supabase";
import { AdminError, createPage } from "@/lib/admin/mutations";

export const dynamic = "force-dynamic";

const PageCreateSchema = z.object({
  slug: z.string().min(1, "slug is required"),
  title: z.string().optional(),
  content: z.string().optional(),
  seo_title: z.string().optional(),
  seo_description: z.string().optional(),
});

export async function GET(request: NextRequest) {
  const authError = authenticate(request);
  if (authError) return authError;

  const siteId =
    await getCurrentSiteId();

  const { data, error } = await getSupabaseAdmin()
    .from("pages")
    .select("*")
    .eq("site_id", siteId)
    .order("slug");

  if (error) {
    console.error("[GET /api/admin/pages]", error);
    return Response.json({ error: "Could not load pages." }, { status: 500 });
  }

  return Response.json({ pages: data });
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

  const parsed = PageCreateSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json(
      { error: parsed.error.issues[0].message },
      { status: 400 }
    );
  }

  // Write through the shared mutation layer: it scopes to this site, compiles
  // the MDX before storing it, enforces slug rules and revalidates.
  try {
    const page = await createPage(parsed.data);
    return Response.json({ page }, { status: 201 });
  } catch (err) {
    if (err instanceof AdminError) {
      return Response.json({ error: err.message }, { status: 400 });
    }
    console.error("[POST /api/admin/pages]", err);
    return Response.json({ error: "Internal error." }, { status: 500 });
  }
}
