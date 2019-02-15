defmodule JournalExApiWeb.ArticleView do
  use JournalExApiWeb, :view
  alias JournalExApiWeb.ArticleResource
  alias JournalExApiWeb.AuthorResource

  def render("index.json", %{
        articles: articles,
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages,
        total_entries: total_entries
      }) do
    %{
      data: Enum.map(articles, &ArticleResource.build/1),
      included: author_resources(articles),
      meta: %{
        page_number: page_number,
        page_size: page_size,
        total_pages: total_pages,
        total_entries: total_entries
      }
    }
  end

  def render("show.json", %{article: article}) do
    %{data: ArticleResource.build(article)}
  end

  defp author_resources(articles) do
    articles
    |> Enum.map(& &1.author)
    |> Enum.uniq()
    |> Enum.map(&AuthorResource.build/1)
  end
end
