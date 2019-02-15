defmodule JournalExApi.Journals.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias JournalExApi.Journals.Article

  schema "authors" do
    has_many :articles, Article

    field :age, :integer
    field :first_name, :string
    field :last_name, :string
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(author, attrs) do
    author
    |> cast(attrs, [:first_name, :last_name, :age])
    |> validate_required([:first_name, :last_name, :age])
    |> validate_number(:age, greater_than: 12)
  end
end
