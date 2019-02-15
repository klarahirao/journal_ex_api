defmodule JournalExApiWeb.ArticleResource do
  @moduledoc false

  def build(article) do
    %{
      id: article.id,
      type: "articles",
      attributes: %{
        title: article.title,
        body: article.body,
        description: article.description,
        published_date: DateTime.to_iso8601(article.published_date)
      },
      relationships: %{
        author: %{
          data: %{type: "authors", id: article.author_id}
        }
      }
    }
  end
end
