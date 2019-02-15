defmodule JournalExApiWeb.ArticleController do
  use JournalExApiWeb, :controller

  alias JournalExApi.Journals
  alias JournalExApi.Journals.Article

  action_fallback JournalExApiWeb.FallbackController

  plug JournalExApiWeb.Plugs.SetCurrentAuthor

  def index(conn, %{"page" => page, "page_size" => page_size}) do
    page = Journals.list_articles(%{page: page, page_size: page_size})

    render(conn, "index.json",
      articles: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end

  def create(conn, %{"article" => params}) do
    with {:ok, %Article{} = article} <-
           Journals.create_article(conn.assigns.current_author, params) do
      conn
      |> put_status(:created)
      |> render("show.json", article: article)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, %Article{} = article} <- Journals.get_article(id),
         :ok <- validate_deleting_article(conn, article),
         {:ok, %Article{}} <- Journals.delete_article(article) do
      send_resp(conn, :no_content, "")
    end
  end

  defp validate_deleting_article(conn, article) do
    if conn.assigns.current_author.id == article.author_id do
      :ok
    else
      {:error, :forbidden}
    end
  end
end
