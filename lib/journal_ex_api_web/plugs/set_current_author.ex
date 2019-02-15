defmodule JournalExApiWeb.Plugs.SetCurrentAuthor do
  import Plug.Conn

  alias JournalExApi.Journals
  alias JournalExApiWeb.Auth.Guardian

  def init(default), do: default

  def call(conn, _opts) do
    with user <- Guardian.Plug.current_resource(conn),
         {:ok, author} <- Journals.author_for_user(user) do
      assign(conn, :current_author, author)
    end
  end
end
