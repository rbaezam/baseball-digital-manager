defmodule BaseballDigitalManager.Repo.Migrations.CreateFieldingStats do
  use Ecto.Migration

  def change do
    create table(:fielding_stats) do
      add :games, :integer
      add :games_started, :integer
      add :complete_games, :integer
      add :inning_played_in_field, :integer
      add :defensive_chances, :integer
      add :putouts, :integer
      add :assists, :integer
      add :errors, :integer
      add :double_plays, :integer
      add :passed_balls, :integer
      add :stolen_bases_allowed, :integer
      add :caught_stealing, :integer
      add :pickoffs, :integer
      add :player_id, references(:players, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)
      add :season_id, references(:seasons, on_delete: :nothing)

      timestamps()
    end

    create index(:fielding_stats, [:player_id])
    create index(:fielding_stats, [:team_id])
    create index(:fielding_stats, [:season_id])
  end
end
