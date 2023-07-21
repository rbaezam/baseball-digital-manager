defmodule BaseballDigitalManager.Repo.Migrations.ChangeGameCascadeDelete do
  use Ecto.Migration

  def change do
    drop(constraint(:game_batting_stats, :game_batting_stats_game_player_id_fkey))
    drop(constraint(:game_pitching_stats, :game_pitching_stats_game_player_id_fkey))
    drop(constraint(:game_fielding_stats, :game_fielding_stats_game_player_id_fkey))

    alter table(:game_batting_stats) do
      modify(:game_player_id, references(:game_players, on_delete: :delete_all))
    end

    alter table(:game_pitching_stats) do
      modify(:game_player_id, references(:game_players, on_delete: :delete_all))
    end

    alter table(:game_fielding_stats) do
      modify(:game_player_id, references(:game_players, on_delete: :delete_all))
    end
  end
end
