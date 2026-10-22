/** Escape text for XML element content. */
export function escapeXml(value: string): string {
  return value
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&apos;");
}

/** Keep embedded feed content from terminating its CDATA block. */
export function escapeCdata(value: string): string {
  return value.replace(/]]>/g, "]]><![CDATA[>");
}
