defmodule BaseballDigitalManager.Repo.Migrations.CreateSeasons do
  use Ecto.Migration

  def change do
    create table(:seasons) do
      add :name, :string
      add :year, :integer
      add :library_id, references(:libraries, on_delete: :nothing)

      timestamps()
    end

    create index(:seasons, [:library_id])
  end
end
