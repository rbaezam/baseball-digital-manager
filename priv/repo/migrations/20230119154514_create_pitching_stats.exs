defmodule BaseballDigitalManager.Repo.Migrations.CreatePitchingStats do
  use Ecto.Migration

  def change do
    create table(:pitching_stats) do
      add :games, :integer
      add :complete_games, :integer
      add :games_started, :integer
      add :closed_games, :integer
      add :wins, :integer
      add :losses, :integer
      add :shutouts, :integer
      add :shared_shutouts, :integer
      add :saves, :integer
      add :outs_pitched, :integer
      add :hits_allowed, :integer
      add :runs_allowed, :integer
      add :earned_runs_allowed, :integer
      add :homeruns_allowed, :integer
      add :base_on_balls, :integer
      add :intentional_base_on_balls, :integer
      add :strikeouts, :integer
      add :hits_by_pitch, :integer
      add :balks, :integer
      add :wild_pitches, :integer
      add :batters_faced, :integer
      add :player_id, references(:players, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)
      add :season_id, references(:seasons, on_delete: :nothing)

      timestamps()
    end

    create index(:pitching_stats, [:player_id])
    create index(:pitching_stats, [:team_id])
    create index(:pitching_stats, [:season_id])
  end
end
