defmodule JournalExApi.Repo.Migrations.CreateAuthors do
  use Ecto.Migration

  def change do
    create table(:authors) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :age, :integer, null: false
      add :user_id, :integer, null: false

      timestamps(type: :timestamptz)
    end

    create unique_index(:authors, [:user_id])
  end
end
