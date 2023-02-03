defmodule BaseballDigitalManager.Repo.Migrations.CreateGameFieldingStats do
  use Ecto.Migration

  def change do
    create table(:game_fielding_stats) do
      add :putouts, :integer, defaults: 0
      add :assists, :integer, defaults: 0
      add :errors, :integer, defaults: 0
      add :passballs, :integer, defaults: 0
      add :game_player_id, references(:game_players, on_delete: :nothing)

      timestamps()
    end

    create index(:game_fielding_stats, [:game_player_id])
  end
end
