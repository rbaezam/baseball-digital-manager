defmodule BaseballDigitalManager.Repo.Migrations.CreateLeagues do
  use Ecto.Migration

  def change do
    create table(:leagues) do
      add :name, :string
      add :short_name, :string
      add :library_id, references(:libraries, on_delete: :nothing)

      timestamps()
    end

    create index(:leagues, [:library_id])
  end
end
