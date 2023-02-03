defmodule BaseballDigitalManager.Repo.Migrations.CreateGamePitchingStats do
  use Ecto.Migration

  def change do
    create table(:game_pitching_stats) do
      add :outs_pitched, :integer, defaults: 0
      add :batters_faced, :integer, defaults: 0
      add :hits, :integer, defaults: 0
      add :runs, :integer, defaults: 0
      add :earned_runs, :integer, defaults: 0
      add :base_on_balls, :integer, defaults: 0
      add :strikeouts, :integer, defaults: 0
      add :wild_pitches, :integer, defaults: 0
      add :balks, :integer, defaults: 0
      add :started_game, :boolean, default: false
      add :closed_game, :boolean, default: false
      add :won_game, :boolean, default: false
      add :lost_game, :boolean, default: false
      add :saved_game, :boolean, default: false
      add :game_player_id, references(:game_players, on_delete: :nothing)

      timestamps()
    end

    create index(:game_pitching_stats, [:game_player_id])
  end
end
