defmodule BaseballDigitalManager.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Stats
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Players.Player

  def get_players_from_team(team_id) do
    IO.inspect(team_id, label: "/// team id ///")

    from(p in Player, where: p.team_id == ^team_id)
    |> Repo.all()
    |> Repo.preload([:batting_stats, :pitching_stats, :fielding_stats])
    |> Enum.map(fn item ->
      %{
        id: item.id,
        team_id: item.team_id,
        first_name: item.first_name,
        last_name: item.last_name,
        full_name: "#{item.first_name} #{item.last_name}",
        bats: item.bats,
        throws: item.throws,
        lineup_position: item.lineup_position,
        main_position: item.main_position,
        batting_stats: List.first(item.batting_stats),
        pitching_stats: List.first(item.pitching_stats),
        fielding_stats: List.first(item.fielding_stats)
      }
    end)
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
end
