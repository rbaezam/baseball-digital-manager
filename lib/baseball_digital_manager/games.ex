defmodule BaseballDigitalManager.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Games.GameFieldingStats
  alias BaseballDigitalManager.Stats.FieldingStats
  alias BaseballDigitalManager.Games.GameBattingStats
  alias BaseballDigitalManager.Games.GamePitchingStats
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Games.Game

  def get!(id) do
    Game
    |> Repo.get(id)
    |> Repo.preload([
      :visitor_team,
      :local_team,
      players: [:player, :batting_stats, :fielding_stats, :pitching_stats]
    ])
  end

  def create(attrs) do
    new_game =
      with {:ok, new_game} <-
             %Game{}
             |> Game.changeset(attrs)
             |> Repo.insert() do
        new_game
        |> Repo.preload(players: [:player, :batting_stats, :fielding_stats, :pitching_stats])
      end

    new_game.players
    |> Enum.map(fn gp ->
      case gp.position do
        "pitcher" ->
          Map.put(gp, :pitching_stats, create_pitching_stats(gp))
          Map.put(gp, :fielding_stats, create_fielding_stats(gp))

        _ ->
          Map.put(gp, :batting_stats, create_batting_stats(gp))
          Map.put(gp, :fielding_stats, create_fielding_stats(gp))
      end
    end)
  end

  defp create_pitching_stats(game_player) do
    %GamePitchingStats{}
    |> GamePitchingStats.changeset(%{
      game_player_id: game_player.id
    })
    |> Repo.insert()
  end

  defp create_batting_stats(game_player) do
    %GameBattingStats{}
    |> GameBattingStats.changeset(%{game_player_id: game_player.id})
    |> Repo.insert()
  end

  defp create_fielding_stats(game_player) do
    %GameFieldingStats{}
    |> GameFieldingStats.changeset(%{game_player_id: game_player.id})
    |> Repo.insert()
  end
end
