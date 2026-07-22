import { NextRequest } from "next/server";
import { z } from "zod";
import { authenticate } from "@/lib/auth";
import { getSupabaseAdmin, getCurrentSiteId } from "@/lib/supabase";
// Shared with the dashboard's media library so the two can't drift apart. This
// route previously hardcoded "media", a bucket that does not exist in this
// project, so every upload through it failed.
import { MEDIA_BUCKET, ALLOWED_TYPES, MAX_UPLOAD_BYTES } from "@/lib/admin/media";

export const dynamic = "force-dynamic";

const MediaUploadSchema = z.object({
  filename: z.string().min(1, "filename is required"),
  data: z.string().min(1, "data (base64) is required"),
  content_type: z.string().optional(),
});


export async function POST(request: NextRequest) {
  const authError = authenticate(request);
  if (authError) return authError;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return Response.json({ error: "Invalid JSON." }, { status: 400 });
  }

  const parsed = MediaUploadSchema.safeParse(body);
  if (!parsed.success) {
    return Response.json(
      { error: parsed.error.issues[0].message },
      { status: 400 }
    );
  }

  const siteId = await getCurrentSiteId();

  const { data: site } = await getSupabaseAdmin()
    .from("sites")
    .select("slug")
    .eq("id", siteId)
    .single();

  if (!site) {
    return Response.json({ error: "Site not found." }, { status: 404 });
  }

  const base64Data = parsed.data.data.replace(/^data:[^;]+;base64,/, "");
  const buffer = Buffer.from(base64Data, "base64");

  if (buffer.byteLength > MAX_UPLOAD_BYTES) {
    return Response.json(
      { error: `File exceeds the ${MAX_UPLOAD_BYTES / 1024 / 1024}MB limit.` },
      { status: 413 }
    );
  }

  // The bucket is PUBLIC, so a caller-supplied content_type is untrusted: an
  // uploaded HTML/SVG file served with text/html would be stored XSS on our own
  // origin. Ignore anything outside the allowlist and derive the type from the
  // filename extension, rejecting what we can't classify as an image or PDF.
  const claimed = parsed.data.content_type;
  const inferred = inferContentType(parsed.data.filename);
  const contentType =
    claimed && ALLOWED_TYPES.has(claimed) ? claimed : inferred;

  if (!contentType || !ALLOWED_TYPES.has(contentType)) {
    return Response.json(
      { error: "Unsupported file type. Upload a JPEG, PNG, GIF, WebP, AVIF or PDF." },
      { status: 415 }
    );
  }

  // Normalise the filename so a caller can't traverse out of the site folder or
  // inject characters that need URL-escaping.
  const safeName = parsed.data.filename
    .replace(/^.*[\\/]/, "")
    .replace(/[^a-zA-Z0-9._-]/g, "-")
    .slice(-100);

  const storagePath = `${site.slug}/${Date.now()}-${safeName}`;

  const { error: uploadError } = await getSupabaseAdmin()
    .storage
    .from(MEDIA_BUCKET)
    .upload(storagePath, buffer, { contentType, upsert: false });

  if (uploadError) {
    console.error("[POST /api/admin/media]", uploadError);
    return Response.json({ error: "Upload failed." }, { status: 500 });
  }

  const { data: publicUrlData } = getSupabaseAdmin()
    .storage
    .from(MEDIA_BUCKET)
    .getPublicUrl(storagePath);

  return Response.json(
    { url: publicUrlData.publicUrl, path: storagePath },
    { status: 201 }
  );
}

function inferContentType(filename: string): string | null {
  const ext = filename.split(".").pop()?.toLowerCase();
  const map: Record<string, string> = {
    jpg: "image/jpeg",
    jpeg: "image/jpeg",
    png: "image/png",
    gif: "image/gif",
    webp: "image/webp",
    svg: "image/svg+xml",
    pdf: "application/pdf",
  };
  return ext ? (map[ext] ?? null) : null;
}
