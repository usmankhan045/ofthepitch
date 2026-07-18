"use server";

import { revalidatePath } from "next/cache";
import { postPath } from "@/lib/utils";

export function revalidatePost(slug: string) {
  revalidatePath(postPath(slug));
}

export function revalidateCategory(slug: string) {
  revalidatePath(`/category/${slug}`);
  revalidatePath("/blog");
}

export function revalidateSite() {
  revalidatePath("/", "layout");
}
