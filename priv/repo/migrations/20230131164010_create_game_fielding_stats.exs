defmodule BaseballDigitalManager.Repo.Migrations.CreateGameFieldingStats do
  use Ecto.Migration

  def change do
    create table(:game_fielding_stats) do
      add :putouts, :integer, defaults: 0, null: false
      add :assists, :integer, defaults: 0, null: false
      add :errors, :integer, defaults: 0, null: false
      add :passballs, :integer, defaults: 0, null: false
      add :game_player_id, references(:game_players, on_delete: :nothing)

      timestamps()
    end

    create index(:game_fielding_stats, [:game_player_id])
  end
end
