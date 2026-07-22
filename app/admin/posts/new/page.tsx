import { listCategories, listPrintables } from "@/lib/admin/data";
import { createPostAction } from "@/lib/admin/actions";
import { PageHeader } from "../../ui";
import PostForm from "../PostForm";

export const dynamic = "force-dynamic";

export default async function NewPostPage() {
  const [categories, { printables }] = await Promise.all([
    listCategories(),
    listPrintables(),
  ]);

  return (
    <>
      <PageHeader
        title="New post"
        description="Answer the reader's question in the first paragraph. No throat-clearing."
      />
      <PostForm
        action={createPostAction}
        categories={categories}
        printables={printables}
        submitLabel="Create post"
      />
    </>
  );
}
