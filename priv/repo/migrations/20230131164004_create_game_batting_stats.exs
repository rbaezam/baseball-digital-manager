defmodule BaseballDigitalManager.Repo.Migrations.CreateGameBattingStats do
  use Ecto.Migration

  def change do
    create table(:game_batting_stats) do
      add :at_bats, :integer, defaults: 0
      add :hits, :integer, defaults: 0
      add :doubles, :integer, defaults: 0
      add :triples, :integer, defaults: 0
      add :homeruns, :integer, defaults: 0
      add :runs, :integer, defaults: 0
      add :rbis, :integer, defaults: 0
      add :base_on_balls, :integer, defaults: 0
      add :intentional_base_on_balls, :integer, defaults: 0
      add :strikeouts, :integer, defaults: 0
      add :stolen_bases, :integer, defaults: 0
      add :caught_stealing, :integer, defaults: 0
      add :sacrifice_hits, :integer, defaults: 0
      add :sacrifice_flies, :integer, defaults: 0
      add :gidp, :integer, defaults: 0
      add :hbp, :integer, defaults: 0
      add :game_player_id, references(:game_players, on_delete: :nothing)

      timestamps()
    end

    create index(:game_batting_stats, [:game_player_id])
  end
end
