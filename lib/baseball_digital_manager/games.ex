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
  alias BaseballDigitalManager.Stats
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Games.Game

  def get!(id, season_id) do
    game =
      Game
      |> Repo.get(id)
      |> Repo.preload([
        :visitor_team,
        :local_team,
        players: [
          :batting_stats,
          :fielding_stats,
          :pitching_stats,
          player: [
            :batting_stats,
            :pitching_stats,
            :fielding_stats,
            :game_pitching_stats,
            :game_batting_stats
          ]
        ]
      ])

    # players_with_info =
    #   game.players
    #   |> Enum.map(fn item ->
    #     %{
    #       id: item.id,
    #       team_id: item.team_id,
    #       first_name: item.player.first_name,
    #       last_name: item.player.last_name,
    #       full_name: "#{item.player.first_name} #{item.player.last_name}",
    #       bats: Players.format_short_bats(item.player.bats),
    #       throws: Players.format_short_throws(item.player.throws),
    #       lineup_position: item.player.lineup_position,
    #       main_position: item.player.main_position,
    #       pos_short: Players.format_short_pos(item.player.main_position),
    #       batting_stats: Stats.get_batting_stats_for_player(item.id, item.team_id, season_id),
    #       pitching_stats: Stats.get_pitching_stats_for_player(item.id, item.team_id, season_id),
    #       # batting_stats: List.first(item.batting_stats),
    #       # pitching_stats: List.first(item.pitching_stats),
    #       fielding_stats: List.first(item.player.fielding_stats),
    #       last_game_pitching: maybe_get_last_game_pitching(item.player),
    #       avg: Players.calculate_avg(item.player),
    #       obs: Players.calculate_obs(item.player),
    #       slg: Players.calculate_slg(item.player),
    #       era: Players.calculate_era(item.player),
    #       innings_pitched: Players.calculate_ip(item.player),
    #       whip: Players.calculate_whip(item.player)
    #     }
    #   end)

    # Map.put(game, :players, players_with_info)
  end

  def get_games(%{current_date: date, id: id}) do
    from(g in Game,
      where: g.library_id == ^id,
      where: g.date == ^date,
      preload: [:visitor_team, :local_team, players: [:pitching_stats, player: [:pitching_stats]]]
    )
    |> Repo.all()
  end

  def get_games(%{id: id}, date) do
    from(g in Game,
      where: g.library_id == ^id,
      where: g.date == ^date,
      preload: [:visitor_team, :local_team, players: [:pitching_stats, player: [:pitching_stats]]]
    )
    |> Repo.all()
  end

  def setup_game(game, %{
        visitor_lineup: visitor_lineup,
        local_lineup: local_lineup,
        visitor_pitcher: visitor_pitcher,
        local_pitcher: local_pitcher
      }) do
    reset_game_data(game)

    visitor_lineup
    |> Enum.map(fn batter ->
      attrs = %{
        player_id: batter.player_id,
        team_id: game.visitor_team_id,
        game_id: game.id,
        position: batter.position,
        is_local_team: false,
        lineup_position: batter.order
      }

      with {:ok, new_game_player} <- create_game_player(attrs) do
        create_batting_stats(new_game_player)
        create_fielding_stats(new_game_player)
      end
    end)

    visitor_pitcher_attrs = %{
      player_id: visitor_pitcher.id,
      team_id: game.visitor_team_id,
      game_id: game.id,
      position: :pitcher,
      is_local_team: false,
      lineup_position: 0
    }

    with {:ok, new_game_player} <- create_game_player(visitor_pitcher_attrs) do
      create_pitching_stats(new_game_player)
      create_fielding_stats(new_game_player)
    end

    local_lineup
    |> Enum.map(fn batter ->
      attrs = %{
        player_id: batter.player_id,
        team_id: game.local_team_id,
        game_id: game.id,
        position: batter.position,
        is_local_team: true,
        lineup_position: batter.order
      }

      with {:ok, new_game_player} <- create_game_player(attrs) do
        create_batting_stats(new_game_player)
        create_fielding_stats(new_game_player)
      end
    end)

    local_pitcher_attrs = %{
      player_id: local_pitcher.id,
      team_id: game.local_team_id,
      game_id: game.id,
      position: :pitcher,
      is_local_team: true,
      lineup_position: 0
    }

    with {:ok, new_game_player} <- create_game_player(local_pitcher_attrs) do
      create_pitching_stats(new_game_player)
      create_fielding_stats(new_game_player)
    end
  end

  defp reset_game_data(game) do
    from(gp in GamePlayer, where: gp.game_id == ^game.id)
    |> Repo.delete_all()
  end

  defp create_game_player(attrs) do
    %GamePlayer{}
    |> GamePlayer.changeset(attrs)
    |> Repo.insert()
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

    %{players: game_players} = game = get!(game.id, 1)

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
    Repo.update(GameFieldingStats.changeset(fielding_stats, attrs))
  end

  def get_winner_pitcher(game) do
    game.players
    |> Enum.filter(&(&1.position == :pitcher))
    |> Enum.find(fn item ->
      item.pitching_stats.won_game
    end)
  end

  def get_loser_pitcher(game) do
    game.players
    |> Enum.filter(&(&1.position == :pitcher))
    |> Enum.find(fn item ->
      item.pitching_stats.lost_game
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

  defp maybe_get_last_game_pitching(%{game_pitching_stats: game_pitching_stats}) do
    List.last(game_pitching_stats)
  end
end
