defmodule JournalExApiWeb.AuthorResource do
  @moduledoc false

  def build(author) do
    %{
      id: author.id,
      type: "authors",
      attributes: %{
        first_name: author.first_name,
        last_name: author.last_name,
        age: author.age
      }
    }
  end
end
