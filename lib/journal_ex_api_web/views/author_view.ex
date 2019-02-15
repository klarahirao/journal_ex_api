defmodule JournalExApiWeb.AuthorView do
  use JournalExApiWeb, :view
  alias JournalExApiWeb.AuthorResource

  def render("author.json", %{author: author}) do
    %{data: AuthorResource.build(author)}
  end
end
