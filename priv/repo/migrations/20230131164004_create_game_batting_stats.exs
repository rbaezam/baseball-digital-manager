defmodule BaseballDigitalManager.Repo.Migrations.CreateGameBattingStats do
  use Ecto.Migration

  def change do
    create table(:game_batting_stats) do
      add :at_bats, :integer, defaults: 0, null: false
      add :hits, :integer, defaults: 0, null: false
      add :doubles, :integer, defaults: 0, null: false
      add :triples, :integer, defaults: 0, null: false
      add :homeruns, :integer, defaults: 0, null: false
      add :runs, :integer, defaults: 0, null: false
      add :rbis, :integer, defaults: 0, null: false
      add :base_on_balls, :integer, defaults: 0, null: false
      add :strikeouts, :integer, defaults: 0, null: false
      add :stolen_bases, :integer, defaults: 0, null: false
      add :caught_stealing, :integer, defaults: 0, null: false
      add :sacrifice_hits, :integer, defaults: 0, null: false
      add :sacrifice_flies, :integer, defaults: 0, null: false
      add :gidp, :integer, defaults: 0, null: false
      add :hbp, :integer, defaults: 0, null: false
      add :game_player_id, references(:game_players, on_delete: :nothing)

      timestamps()
    end

    create index(:game_batting_stats, [:game_player_id])
  end
end
