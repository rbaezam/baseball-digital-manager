defmodule BaseballDigitalManager.Games do
  @moduledoc """
  The Games context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Players
  alias BaseballDigitalManager.Games.GameFieldingStats
  alias BaseballDigitalManager.Games.GamePlayer
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

  def get_games(date) do
    from(g in Game, where: g.date == ^date, preload: [:visitor_team, :local_team])
    |> Repo.all()
  end

  def create_game(attrs) do
    new_game =
      with {:ok, new_game} <-
             %Game{}
             |> Game.changeset(attrs)
             |> Repo.insert() do
        new_game
        |> Repo.preload(players: [:player, :batting_stats, :fielding_stats, :pitching_stats])
      end

    players =
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

    {new_game, players}
  end

  def update_game(game, attrs) do
    game = Game |> Repo.get(game.id)

    {:ok, game} = Repo.update(Game.changeset(game, attrs))

    %{players: game_players} = game = get!(game.id)

    game_players
    |> Enum.map(fn gp ->
      if gp.batting_stats != nil do
        Players.update_batting_stats(gp.player, gp.batting_stats)
      else
        if gp.player.main_position != :pitcher do
          gp
          |> Map.put(:batting_stats, create_batting_stats(gp))
          |> Map.put(:fielding_stats, create_fielding_stats(gp))
        end
      end

      if gp.pitching_stats != nil do
        Players.update_pitching_stats(gp.player, gp.pitching_stats)
      else
        if gp.player.main_position == :pitcher do
          gp
          |> Map.put(:pitching_stats, create_pitching_stats(gp))
          |> Map.put(:fielding_stats, create_fielding_stats(gp))
        end
      end

      if gp.fielding_stats != nil do
        Players.update_fielding_stats(gp.player, gp.fielding_stats)
      end
    end)

    game
  end

  def update_game_player(game_player, attrs) do
    Repo.update(GamePlayer.changeset(game_player, attrs))
  end

  def update_batting_stats(batting_stats, attrs) do
    Repo.update(GameBattingStats.changeset(batting_stats, attrs))
  end

  def update_pitching_stats(pitching_stats, attrs) do
    Repo.update(GamePitchingStats.changeset(pitching_stats, attrs))
  end

  def update_fielding_stats(fielding_stats, attrs) do
    IO.inspect(attrs, label: "/ attrs /")
    Repo.update(GameFieldingStats.changeset(fielding_stats, attrs))
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
