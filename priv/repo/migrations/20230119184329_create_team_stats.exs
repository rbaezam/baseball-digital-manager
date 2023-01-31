defmodule BaseballDigitalManager.Repo.Migrations.CreateTeamStats do
  use Ecto.Migration

  def change do
    create table(:team_stats) do
      add :wins, :integer
      add :losses, :integer
      add :team_id, references(:teams, on_delete: :nothing)
      add :season_id, references(:seasons, on_delete: :nothing)

      timestamps()
    end

    create index(:team_stats, [:team_id])
    create index(:team_stats, [:season_id])
  end
end
