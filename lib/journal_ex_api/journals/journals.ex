defmodule JournalExApi.Journals do
  @moduledoc """
  The Journal context.
  """

  import Ecto.Query, warn: false
  alias JournalExApi.Repo

  alias JournalExApi.Accounts

  alias JournalExApi.Journals.{
    Article,
    Author
  }

  @doc """
  Returns paginated list of articles.
  """
  def list_articles(params \\ %{}) do
    Article
    |> order_by(desc: :published_date)
    |> preload(:author)
    |> Repo.paginate(params)
  end

  @doc """
  Gets a single article or returns an error.
  """
  def get_article(id) do
    case Repo.get(Article, id) do
      nil -> {:error, :not_found}
      article -> {:ok, article}
    end
  end

  @doc """
  Gets a single author or returns an error.
  """
  def get_author(id) do
    case Repo.get(Author, id) do
      nil -> {:error, :not_found}
      author -> {:ok, author}
    end
  end

  @doc """
  Creates a article.
  """
  def create_article(%Author{} = author, attrs \\ %{}) do
    %Article{}
    |> Article.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:author, author)
    |> Ecto.Changeset.put_change(
      :published_date,
      DateTime.utc_now() |> DateTime.truncate(:second)
    )
    |> Repo.insert()
  end

  @doc """
  Creates a author.
  """
  def create_author(%Accounts.User{} = user, attrs \\ %{}) do
    %Author{}
    |> Author.changeset(attrs)
    |> Ecto.Changeset.put_change(:user_id, user.id)
    |> Repo.insert()
  end

  @doc """
  Deletes a Article.
  """
  def delete_article(%Article{} = article) do
    Repo.delete(article)
  end

  @doc """
  Updates a author.
  """
  def update_author(%Author{} = author, attrs) do
    author
    |> Author.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Gets a single author for user or returns and error.
  """
  def author_for_user(%Accounts.User{} = user) do
    case Repo.get_by(Author, user_id: user.id) do
      nil -> {:error, :not_found}
      author -> {:ok, author}
    end
  end
end
