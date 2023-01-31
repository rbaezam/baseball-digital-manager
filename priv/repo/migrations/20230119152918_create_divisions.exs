defmodule BaseballDigitalManager.Repo.Migrations.CreateDivisions do
  use Ecto.Migration

  def change do
    create table(:divisions) do
      add :name, :string
      add :short_name, :string
      add :league_id, references(:leagues, on_delete: :nothing)

      timestamps()
    end

    create index(:divisions, [:league_id])
  end
end
