defmodule BaseballDigitalManager.Stats do
  @moduledoc """
  The Stats context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Repo
  alias BaseballDigitalManager.Players.Player
  alias BaseballDigitalManager.Stats.{BattingStats, FieldingStats, PitchingStats}

  def homerun_leaders(count \\ 5) do
    from(bs in BattingStats,
      preload: [player: [:team]],
      order_by: [desc: :homeruns],
      limit: ^count
    )
    |> Repo.all()
    |> Enum.map(fn item ->
      %{
        id: item.player.id,
        team_id: item.player.team.id,
        team_name: item.player.team.nick_name,
        first_name: item.player.first_name,
        last_name: item.player.last_name,
        full_name: "#{item.player.first_name} #{item.player.last_name}",
        bats: item.player.bats,
        lineup_position: item.player.lineup_position,
        main_position: item.player.main_position,
        batting_stats: item
      }
    end)
  end

  def strikeout_leaders(count \\ 5) do
    from(ps in PitchingStats,
      preload: [player: [:team]],
      order_by: [desc: :strikeouts],
      limit: ^count
    )
    |> Repo.all()
    |> Enum.map(fn item ->
      %{
        id: item.player.id,
        team_id: item.player.team.id,
        team_name: item.player.team.nick_name,
        first_name: item.player.first_name,
        last_name: item.player.last_name,
        full_name: "#{item.player.first_name} #{item.player.last_name}",
        throws: item.player.throws,
        main_position: item.player.main_position,
        pitching_stats: item
      }
    end)
  end

  def get_batting_stats_for_player(player_id, team_id, season_id) do
    case from(bs in BattingStats,
           where:
             bs.player_id == ^player_id and bs.team_id == ^team_id and bs.season_id == ^season_id
         )
         |> Repo.all()
         |> List.first() do
      nil ->
        create_batting_stats(%{player_id: player_id, team_id: team_id, season_id: season_id})

      batting_stats ->
        batting_stats
    end
  end

  def get_pitching_stats_for_player(player_id, team_id, season_id) do
    case from(ps in PitchingStats,
           where:
             ps.player_id == ^player_id and ps.team_id == ^team_id and ps.season_id == ^season_id
         )
         |> Repo.all()
         |> List.first() do
      nil ->
        create_pitching_stats(%{player_id: player_id, team_id: team_id, season_id: season_id})

      pitching_stats ->
        pitching_stats
    end
  end

  def get_fielding_stats_for_player(player_id, team_id, season_id) do
    case from(ps in FieldingStats,
           where:
             ps.player_id == ^player_id and ps.team_id == ^team_id and ps.season_id == ^season_id
         )
         |> Repo.all()
         |> List.first() do
      nil ->
        create_fielding_stats(%{player_id: player_id, team_id: team_id, season_id: season_id})

      fielding_stats ->
        fielding_stats
    end
  end

  def create_batting_stats(attrs) do
    with {:ok, batting_stats} <-
           %BattingStats{}
           |> BattingStats.changeset(attrs)
           |> Repo.insert() do
      batting_stats
    end
  end

  def create_pitching_stats(attrs) do
    with {:ok, pitching_stats} <-
           %PitchingStats{}
           |> PitchingStats.changeset(attrs)
           |> Repo.insert() do
      pitching_stats
    end
  end

  def create_fielding_stats(attrs) do
    with {:ok, fielding_stats} <-
           %FieldingStats{}
           |> FieldingStats.changeset(attrs)
           |> Repo.insert() do
      fielding_stats
    end
  end

  def update_batting_stats(stats, attrs) do
    new_attrs = %{
      at_bats: stats.at_bats + attrs.at_bats,
      base_on_balls: stats.base_on_balls + attrs.base_on_balls,
      caught_stealing: stats.caught_stealing + attrs.caught_stealing,
      doubles: stats.doubles + attrs.doubles,
      games: stats.games + 1,
      grounded_into_doubleplays: stats.grounded_into_doubleplays + attrs.gidp,
      hit_by_pitch: stats.hit_by_pitch + attrs.hbp,
      hits: stats.hits + attrs.hits,
      homeruns: stats.homeruns + attrs.homeruns,
      intentional_base_on_balls:
        stats.intentional_base_on_balls + attrs.intentional_base_on_balls,
      plate_appearances:
        stats.plate_appearances + attrs.at_bats + attrs.base_on_balls + attrs.hbp +
          attrs.sacrifice_hits + attrs.sacrifice_flies,
      rbis: stats.rbis + attrs.rbis,
      runs: stats.runs + attrs.runs,
      sacrifice_flies: stats.sacrifice_flies + attrs.sacrifice_flies,
      sacrifice_hits: stats.sacrifice_hits + attrs.sacrifice_hits,
      stolen_bases: stats.stolen_bases + attrs.stolen_bases,
      strikeouts: stats.strikeouts + attrs.strikeouts,
      triples: stats.triples + attrs.triples
    }

    with {:ok, stats} <- Repo.update(BattingStats.changeset(stats, new_attrs)) do
      stats
    end
  end

  def update_pitching_stats(stats, attrs) do
    new_attrs = %{
      balks: stats.balks + attrs.balks,
      base_on_balls: stats.base_on_balls + attrs.base_on_balls,
      batters_faced: stats.batters_faced + attrs.batters_faced,
      earned_runs_allowed: stats.earned_runs_allowed + attrs.earned_runs,
      hits_allowed: stats.hits_allowed + attrs.hits,
      hits_by_pitch: stats.hits_by_pitch + attrs.hits_by_pitch,
      homeruns_allowed: stats.homeruns_allowed + attrs.homeruns_allowed,
      intentional_base_on_balls:
        stats.intentional_base_on_balls + attrs.intentional_base_on_balls,
      outs_pitched: stats.outs_pitched + attrs.outs_pitched,
      runs_allowed: stats.runs_allowed + attrs.runs,
      strikeouts: stats.strikeouts + attrs.strikeouts,
      wild_pitches: stats.wild_pitches + attrs.wild_pitches,
      games: stats.games + 1,
      games_started:
        if attrs.started_game do
          stats.games_started + 1
        else
          stats.games_started
        end,
      complete_games:
        if attrs.closed_game do
          stats.complete_games + 1
        else
          stats.complete_games
        end,
      closed_games: 0,
      saves:
        if attrs.saved_game do
          stats.saves + 1
        else
          stats.saves
        end,
      shutouts:
        if attrs.started_game and attrs.closed_game and attrs.runs == 0 do
          stats.shutouts + 1
        else
          stats.shutouts
        end,
      wins:
        if attrs.won_game do
          stats.wins + 1
        else
          stats.wins
        end,
      losses:
        if attrs.lost_game do
          stats.losses + 1
        else
          stats.losses
        end,
      shared_shutouts: 0
    }

    with {:ok, stats} <- Repo.update(PitchingStats.changeset(stats, new_attrs)) do
      stats
    end
  end

  def update_fielding_stats(stats, attrs) do
    new_attrs = %{
      games: stats.games + 1,
      games_started: stats.games_started + 1,
      complete_games: stats.complete_games + 1,
      inning_played_in_field: stats.inning_played_in_field + 9,
      defensive_chances: stats.defensive_chances + attrs.putouts + attrs.assists + attrs.errors,
      putouts: stats.putouts + attrs.putouts,
      assists: stats.assists + attrs.assists,
      errors: stats.errors + attrs.errors,
      passed_balls: stats.passed_balls + attrs.passballs
    }

    with {:ok, stats} <- Repo.update(FieldingStats.changeset(stats, new_attrs)) do
      stats
    end
  end
end
