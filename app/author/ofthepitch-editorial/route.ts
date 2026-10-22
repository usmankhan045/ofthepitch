/** Preserve the legacy author URL with the exact 301 requested for migration. */
export function GET() {
  return Response.redirect(
    "https://www.ofthepitch.com/author/muhammad-usman",
    301
  );
}
