defmodule JournalExApi.Repo.Migrations.CreateArticles do
  use Ecto.Migration

  def change do
    create table(:articles) do
      add :title, :string, null: false
      add :body, :text, null: false
      add :description, :text
      add :published_date, :utc_datetime, null: false
      add :author_id, references(:authors, on_delete: :delete_all), null: false
    end

    create index(:articles, [:author_id])
  end
end
