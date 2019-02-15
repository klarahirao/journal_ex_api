defmodule JournalExApi.Journals.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias JournalExApi.Journals.Author

  schema "articles" do
    belongs_to :author, Author

    field :body, :string
    field :description, :string
    field :published_date, :utc_datetime
    field :title, :string
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :description])
    |> validate_required([:title, :body])
    |> validate_length(:title, max: 150)
  end
end
