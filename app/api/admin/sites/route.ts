import { NextRequest } from "next/server";
import { authenticate } from "@/lib/auth";
import { getSupabaseAdmin } from "@/lib/supabase";

export const dynamic = "force-dynamic";

export async function GET(request: NextRequest) {
  const authError = authenticate(request);
  if (authError) return authError;

  const { data, error } = await getSupabaseAdmin()
    .from("sites")
    .select("*")
    .order("created_at", { ascending: true });

  if (error) {
    console.error("[GET /api/admin/sites]", error);
    return Response.json({ error: "Could not load sites." }, { status: 500 });
  }

  return Response.json({ sites: data });
}

/**
 * Provisioning new tenants is deliberately NOT available here.
 *
 * `sites` is the tenant registry for a Supabase project shared with several
 * other live sites. A per-site deployment holding ADMIN_API_TOKEN has no
 * legitimate reason to create rows in it, and doing so by accident would add an
 * unmanaged tenant. Create sites through the Supabase dashboard instead.
 */
export async function POST() {
  return Response.json(
    { error: "Creating sites is not permitted from this deployment." },
    { status: 403 }
  );
}
