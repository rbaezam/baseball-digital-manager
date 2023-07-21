defmodule BaseballDigitalManager.Repo.Migrations.CreateTeamLineups do
  use Ecto.Migration

  def change do
    create table(:team_lineups) do
      add :name, :string
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:team_lineups, [:team_id])
  end
end
