defmodule BaseballDigitalManager.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Stats
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Players.Player

  def create_batter(params) do
    %Player{}
    |> Player.changeset(params)
    |> Repo.insert()
  end

  def create_pitcher(params) do
    %Player{}
    |> Player.changeset(params)
    |> Repo.insert()
  end

  def get_players_from_team(team_id, season_id, sort_by \\ "name", sort_direction \\ "asc") do
    sort_by_atom = String.to_atom(sort_by)
    # players =
    from(p in Player,
      where: p.team_id == ^team_id,
      order_by: [asc: :first_name],
      preload: [
        :batting_stats,
        :pitching_stats,
        :fielding_stats,
        :game_batting_stats,
        game_pitching_stats: [game_player: :game],
        game_players: [:pitching_stats, :batting_stats]
      ]
    )
    |> Repo.all()
    |> Enum.map(fn item ->
      item
      |> Map.put(
        :batting_stats,
        Stats.get_batting_stats_for_player(item.id, item.team_id, season_id)
      )
      |> Map.put(
        :pitching_stats,
        Stats.get_pitching_stats_for_player(item.id, item.team_id, season_id)
      )
      |> Map.put(:last_game_pitching, List.last(item.game_pitching_stats))
    end)
    |> Enum.map(fn item ->
      %{
        id: item.id,
        team_id: item.team_id,
        first_name: item.first_name,
        last_name: item.last_name,
        full_name: "#{item.first_name} #{item.last_name}",
        bats: format_short_bats(item.bats),
        throws: format_short_throws(item.throws),
        lineup_position: item.lineup_position,
        main_position: item.main_position,
        pos_short: format_short_pos(item.main_position),
        batting_stats: item.batting_stats,
        pitching_stats: item.pitching_stats,
        last_game_pitching: item.last_game_pitching,
        fielding_stats: List.first(item.fielding_stats),
        avg: calculate_avg(item),
        hr: item.batting_stats.homeruns,
        rbi: item.batting_stats.rbis,
        obs: calculate_obs(item),
        slg: calculate_slg(item),
        ops: calculate_ops(item),
        era: calculate_era(item),
        innings_pitched: calculate_ip(item),
        whip: calculate_whip(item)
      }
    end)
    |> Enum.sort_by(&sort_by_direction(&1, sort_by_atom), String.to_atom(sort_direction))
  end

  defp sort_by_direction(item, field) do
    Map.get(item, field)
  end

  def update_batting_stats(player, attrs) do
    Stats.get_batting_stats_for_player(player.id, player.team_id, 1)
    |> IO.inspect(label: "*** batting stats ***")
    |> Stats.update_batting_stats(attrs)
  end

  def update_pitching_stats(player, attrs) do
    Stats.get_pitching_stats_for_player(player.id, player.team_id, 1)
    |> IO.inspect(label: "*** pitching stats ***")
    |> Stats.update_pitching_stats(attrs)
  end

  def update_fielding_stats(player, attrs) do
    Stats.get_fielding_stats_for_player(player.id, player.team_id, 1)
    |> IO.inspect(label: "*** fielding stats ***")
    |> Stats.update_fielding_stats(attrs)
  end

  def calculate_avg(player) do
    stats = player.batting_stats

    if stats != nil and Decimal.compare(stats.at_bats, 0) != :eq do
      String.replace(
        Decimal.to_string(
          Decimal.round(
            Decimal.div(
              Decimal.new(stats.hits),
              Decimal.new(stats.at_bats)
            ),
            3
          )
        ),
        "0.",
        "."
      )
    else
      ".000"
    end
  end

  def calculate_obs(player) do
    stats = player.batting_stats

    if stats != nil and Decimal.compare(stats.at_bats, 0) != :eq do
      on_base = stats.hits + stats.base_on_balls + stats.hit_by_pitch

      total_at_bats =
        stats.at_bats + stats.base_on_balls + stats.hit_by_pitch + stats.sacrifice_flies

      String.replace(
        Decimal.to_string(
          Decimal.round(
            Decimal.div(
              Decimal.new(on_base),
              Decimal.new(total_at_bats)
            ),
            3
          )
        ),
        "0.",
        "."
      )
    else
      ".000"
    end
  end

  def calculate_slg(player) do
    stats = player.batting_stats

    if stats != nil && stats.at_bats > 0 do
      total_bases =
        stats.doubles * 2 + stats.triples * 3 + stats.homeruns * 4 +
          (stats.hits - stats.doubles - stats.triples - stats.homeruns)

      String.replace(
        Decimal.to_string(
          Decimal.round(
            Decimal.div(
              Decimal.new(total_bases),
              Decimal.new(stats.at_bats)
            ),
            3
          )
        ),
        "0.",
        "."
      )
    else
      ".000"
    end
  end

  def calculate_ops(player) do
    stats = player.batting_stats

    if stats != nil and Decimal.compare(stats.at_bats, 0) != :eq do
      on_base = stats.hits + stats.base_on_balls + stats.hit_by_pitch

      total_bases =
        stats.doubles * 2 + stats.triples * 3 + stats.homeruns * 4 +
          (stats.hits - stats.doubles - stats.triples - stats.homeruns)

      total_at_bats =
        stats.at_bats + stats.base_on_balls + stats.hit_by_pitch + stats.sacrifice_flies

      slg_dec =
        Decimal.div(
          Decimal.new(total_bases),
          Decimal.new(stats.at_bats)
        )

      obp_dec =
        Decimal.div(
          Decimal.new(on_base),
          Decimal.new(total_at_bats)
        )

      String.replace(
        Decimal.to_string(
          Decimal.round(
            Decimal.add(
              slg_dec,
              obp_dec
            ),
            3
          )
        ),
        "0.",
        "."
      )
    else
      ".000"
    end
  end

  def calculate_era(player) do
    stats = player.pitching_stats

    if stats != nil && stats.outs_pitched > 0 do
      Decimal.to_string(
        Decimal.round(
          Decimal.mult(
            9,
            Decimal.div(
              stats.earned_runs_allowed,
              Decimal.div(stats.outs_pitched, 3)
            )
          ),
          2
        )
      )
    else
      "0.00"
    end
  end

  def calculate_ip(player) do
    stats = player.pitching_stats

    if stats != nil && stats.outs_pitched > 0 do
      Decimal.round(Decimal.div(stats.outs_pitched, 3), 1)
    else
      0
    end
  end

  def calculate_whip(player) do
    stats = player.pitching_stats

    if stats != nil && stats.outs_pitched > 0 do
      walks_plus_hits = Decimal.new(stats.base_on_balls + stats.hits_allowed)
      innings_pitched = Decimal.div(stats.outs_pitched, 3)
      Decimal.div(walks_plus_hits, innings_pitched) |> Decimal.round(2) |> Decimal.to_string()
    else
      "0.00"
    end
  end

  def format_short_bats(:left), do: "L"
  def format_short_bats(:right), do: "R"
  def format_short_bats(:switch), do: "S"
  def format_short_bats(bats), do: bats

  def format_short_throws(:left), do: "L"
  def format_short_throws(:right), do: "R"

  def format_short_pos(:pitcher), do: "P"
  def format_short_pos(:catcher), do: "C"
  def format_short_pos(:firstbaseman), do: "1B"
  def format_short_pos(:secondbaseman), do: "2B"
  def format_short_pos(:thirdbaseman), do: "3B"
  def format_short_pos(:shortstop), do: "SS"
  def format_short_pos(:leftfielder), do: "LF"
  def format_short_pos(:centerfielder), do: "CF"
  def format_short_pos(:rightfielder), do: "RF"
  def format_short_pos(:infielder), do: "IF"
  def format_short_pos(:outfielder), do: "OF"
  def format_short_pos(_), do: "--"
end
