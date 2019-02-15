defmodule JournalExApiWeb.AuthorController do
  use JournalExApiWeb, :controller

  alias JournalExApi.Journals
  alias JournalExApi.Journals.Author

  action_fallback JournalExApiWeb.FallbackController

  plug JournalExApiWeb.Plugs.SetCurrentAuthor

  def show(conn, %{"id" => id}) do
    with {:ok, %Author{} = author} <- Journals.get_author(id) do
      render(conn, "author.json", author: author)
    end
  end

  def update(conn, %{"author" => params}) do
    with {:ok, %Author{} = author} <- Journals.update_author(conn.assigns.current_author, params) do
      render(conn, "author.json", author: author)
    end
  end
end
