# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BaseballDigitalManager.Repo.insert!(%BaseballDigitalManager.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias BaseballDigitalManager.{
  Divisions.Division,
  Leagues.League,
  Libraries.Library,
  Players.Player,
  Seasons.Season,
  Teams.Team
}

library =
  BaseballDigitalManager.Repo.insert!(%Library{
    id: 1,
    name: "Negro League Library",
    starting_year: 1930
  })

season =
  BaseballDigitalManager.Repo.insert!(%Season{
    id: 1,
    library_id: library.id,
    name: "Negro League Season 1930",
    year: 1930
  })

league =
  BaseballDigitalManager.Repo.insert!(%League{
    name: "Negro League All Stars",
    short_name: "NLAS",
    library_id: library.id
  })

division1 =
  BaseballDigitalManager.Repo.insert!(%Division{
    name: "Red Division",
    short_name: "RD",
    league_id: league.id
  })

division2 =
  BaseballDigitalManager.Repo.insert!(%Division{
    name: "Blue Division",
    short_name: "BD",
    league_id: league.id
  })

team_atl =
  BaseballDigitalManager.Repo.insert!(%Team{
    name: "Atlanta",
    nick_name: "Black Crackers",
    short_name: "ATL",
    league_id: league.id,
    division_id: division2.id,
    current_season_wins: 0,
    current_season_losses: 0
  })

team_bal =
  BaseballDigitalManager.Repo.insert!(%Team{
    name: "Baltimore",
    nick_name: "Eagles",
    short_name: "BAL",
    league_id: league.id,
    division_id: division1.id,
    current_season_wins: 0,
    current_season_losses: 0
  })

team_chi =
  BaseballDigitalManager.Repo.insert!(%Team{
    name: "Chicago",
    nick_name: "American Giants",
    short_name: "CHI",
    league_id: league.id,
    division_id: division2.id,
    current_season_wins: 0,
    current_season_losses: 0
  })

team_det =
  BaseballDigitalManager.Repo.insert!(%Team{
    name: "Detroit",
    nick_name: "Stars",
    short_name: "DET",
    league_id: league.id,
    division_id: division1.id,
    current_season_wins: 0,
    current_season_losses: 0
  })

team_mem =
  BaseballDigitalManager.Repo.insert!(%Team{
    name: "Memphis",
    nick_name: "Red Sox",
    short_name: "MEM",
    league_id: league.id,
    division_id: division2.id,
    current_season_wins: 0,
    current_season_losses: 0
  })

team_phi =
  BaseballDigitalManager.Repo.insert!(%Team{
    name: "Philladelphia",
    nick_name: "Royals",
    short_name: "PHI",
    league_id: league.id,
    division_id: division1.id,
    current_season_wins: 0,
    current_season_losses: 0
  })

"/Users/rodolfo/Code/Personal/BaseballDigitalManager/baseball_digital_manager/priv/repo/players.csv"
|> File.stream!()
|> CSV.decode(headers: true)
|> Enum.map(fn data -> data end)
|> Enum.map(fn {:ok, row} ->
  IO.inspect(row, label: "// row //")

  BaseballDigitalManager.Repo.insert!(%Player{
    last_name: row["last_name"],
    first_name: row["first_name"],
    bats: String.to_atom(row["bats"]),
    throws: String.to_atom(row["throws"]),
    team_id: String.to_integer(row["team_id"]),
    main_position: String.to_atom(row["main_position"]),
    pitcher_type:
      case row["pitcher_type"] do
        "" -> nil
        pitcher_type -> String.to_atom(pitcher_type)
      end
  })
end)
