defmodule BaseballDigitalManager.Repo.Migrations.AddLineupPositionToPlayers do
  use Ecto.Migration

  def change do
    alter table("game_players") do
      add :lineup_position, :integer, default: 0
    end

    alter table("players") do
      add :lineup_position, :integer, default: 0
    end
  end
end
