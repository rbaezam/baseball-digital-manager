defmodule BaseballDigitalManager.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Stats.BattingStats
  alias BaseballDigitalManager.Teams.Lineup
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Teams.Team

  def get_team!(id) do
    Repo.get!(Team, id)
  end

  def get_teams_from_library(library_id) do
    from(t in Team,
      join: league in assoc(t, :league),
      join: library in assoc(league, :library),
      where: library.id == ^library_id
    )
    |> order_by(asc: :nick_name)
    |> Repo.all()
  end

  def get_team_by_nick_name(nick_name) do
    from(t in Team,
      where: t.nick_name == ^nick_name
    )
    |> Repo.all()
    |> List.first()
  end

  def get_lineup!(id) do
    Lineup |> Repo.get!(id) |> Repo.preload([:items])
  end

  def get_saved_lineups_for_team(team_id) do
    from(l in Lineup,
      where: l.team_id == ^team_id
    )
    |> Repo.all()
  end

  def save_lineup(attrs) do
    %Lineup{}
    |> Lineup.changeset(attrs)
    |> Repo.insert()
    |> IO.inspect(label: "// insert //")
  end

  def get_team_batting_avg(team) do
    {hits, at_bats} =
      from(bs in BattingStats, where: bs.team_id == ^team.id)
      |> Repo.all()
      |> Enum.reduce({0, 0}, fn item, {acc_hits, acc_at_bats} ->
        {item.hits + acc_hits, item.at_bats + acc_at_bats}
      end)

    case at_bats do
      0 ->
        Decimal.from_float(0.000)

      at_bats ->
        Decimal.round(
          Decimal.div(
            Decimal.new(hits),
            Decimal.new(at_bats)
          ),
          3
        )
    end
  end

  def get_team_homeruns(team) do
    from(bs in BattingStats, where: bs.team_id == ^team.id)
    |> Repo.all()
    |> Enum.reduce(0, fn item, acc_hr ->
      item.homeruns + acc_hr
    end)
  end

  def add_game_win(team_id) do
    with team <- get_team!(team_id) do
      wins = team.current_season_wins + 1

      Team.changeset(team, %{current_season_wins: wins})
      |> Repo.update()
    end
  end

  def add_game_lost(team_id) do
    with team <- get_team!(team_id) do
      losses = team.current_season_losses + 1

      Team.changeset(team, %{current_season_losses: losses})
      |> Repo.update()
    end
  end
end
