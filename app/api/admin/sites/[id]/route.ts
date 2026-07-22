import { NextRequest } from "next/server";
import { z } from "zod";
import { authenticate } from "@/lib/auth";
import { getSupabaseAdmin, getCurrentSiteId } from "@/lib/supabase";

export const dynamic = "force-dynamic";

const SiteUpdateSchema = z.object({
  deploy_url: z.string().url("deploy_url must be a valid URL").optional(),
  theme_config: z.record(z.string(), z.unknown()).optional(),
  name: z.string().min(1).optional(),
  niche: z.string().optional(),
});

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

  const parsed = SiteUpdateSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json(
      { error: parsed.error.issues[0].message },
      { status: 400 }
    );
  }

  // This deployment may only edit its OWN site row.
  //
  // The `sites` table is the tenant registry for a Supabase project shared with
  // several other live sites. Without this check, anyone holding
  // ADMIN_API_TOKEN could rewrite another tenant's `deploy_url` — repointing
  // its revalidation webhooks — or rename it outright.
  const currentSiteId = await getCurrentSiteId();
  if (id !== currentSiteId) {
    return Response.json(
      { error: "This deployment can only modify its own site." },
      { status: 403 }
    );
  }

  const { data, error } = await getSupabaseAdmin()
    .from("sites")
    .update(parsed.data)
    .eq("id", currentSiteId)
    .select()
    .single();

  if (error) {
    console.error("[PUT /api/admin/sites/[id]]", error);
    return Response.json({ error: "Could not update site." }, { status: 500 });
  }

  if (!data) {
    return Response.json({ error: "Site not found." }, { status: 404 });
  }

  return Response.json({ site: data });
}
