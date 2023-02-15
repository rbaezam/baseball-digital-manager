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

alias BaseballDigitalManager.Teams

alias BaseballDigitalManager.{
  Divisions.Division,
  Leagues.League,
  Libraries.Library,
  Players.Player,
  Seasons.Season,
  Teams.Team
}

# library =
#   BaseballDigitalManager.Repo.insert!(%Library{
#     id: 1,
#     name: "On-Deck Baseball League Library",
#     starting_year: 2023
#   })

# season =
#   BaseballDigitalManager.Repo.insert!(%Season{
#     id: 1,
#     library_id: library.id,
#     name: "Season 2023",
#     year: 2023
#   })

# league =
#   BaseballDigitalManager.Repo.insert!(%League{
#     name: "OnDeck Baseball League",
#     short_name: "ODBL",
#     library_id: library.id
#   })

# division1 =
#   BaseballDigitalManager.Repo.insert!(%Division{
#     name: "Atlantic Division",
#     short_name: "AD",
#     league_id: league.id
#   })

# division2 =
#   BaseballDigitalManager.Repo.insert!(%Division{
#     name: "Pacific Division",
#     short_name: "PD",
#     league_id: league.id
#   })

# team_bos =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Boston",
#     nick_name: "Gators",
#     short_name: "BOS",
#     league_id: league.id,
#     division_id: division1.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_buf =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Buiffalo",
#     nick_name: "Comets",
#     short_name: "BUF",
#     league_id: league.id,
#     division_id: division1.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_tor =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Toronto",
#     nick_name: "Phantoms",
#     short_name: "TOR",
#     league_id: league.id,
#     division_id: division1.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_ota =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Ottaw",
#     nick_name: "Wolves",
#     short_name: "OTA",
#     league_id: league.id,
#     division_id: division1.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_mon =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Montreal",
#     nick_name: "Drillers",
#     short_name: "MON",
#     league_id: league.id,
#     division_id: division1.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_cal =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Calgary",
#     nick_name: "Makos",
#     short_name: "CAL",
#     league_id: league.id,
#     division_id: division2.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_edm =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Edmonton",
#     nick_name: "Bulls",
#     short_name: "EDM",
#     league_id: league.id,
#     division_id: division2.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_van =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Vancouver",
#     nick_name: "Vipers",
#     short_name: "VAN",
#     league_id: league.id,
#     division_id: division2.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_sj =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "San Jose",
#     nick_name: "Knights",
#     short_name: "SJ",
#     league_id: league.id,
#     division_id: division2.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

# team_cal =
#   BaseballDigitalManager.Repo.insert!(%Team{
#     name: "Vegas",
#     nick_name: "Hornets",
#     short_name: "VEG",
#     league_id: league.id,
#     division_id: division2.id,
#     current_season_wins: 0,
#     current_season_losses: 0
#   })

"/Users/rodolfo/Code/Personal/BaseballDigitalManager/baseball_digital_manager/priv/repo/OnDeckBaseballRosters3.csv"
|> File.stream!()
|> CSV.decode(headers: true)
|> Enum.map(fn data -> data end)
|> Enum.map(fn {:ok, row} ->
  IO.inspect(row, label: "// row //")

  team = Teams.get_team_by_nick_name(row["\uFEFFTeam"])

  bats =
    case row["Bats"] do
      "R" -> :right
      "L" -> :left
      "S" -> :switch
    end

  throws =
    case row["Throws"] do
      "R" -> :right
      "L" -> :left
    end

  secondary_position =
    case row["Position2"] do
      "nil" -> nil
      "" -> nil
      pos -> String.to_atom(pos)
    end

  lineup_position =
    case row["LineupPos"] do
      "" -> nil
      pos -> String.to_integer(pos)
    end

  BaseballDigitalManager.Repo.insert!(%Player{
    last_name: row["LastName"],
    first_name: row["FirstName"],
    bats: bats,
    throws: throws,
    team_id: team.id,
    main_position: String.to_atom(row["Position"]),
    secondary_position: secondary_position,
    lineup_position: lineup_position,
    pitcher_type:
      case row["PitcherType"] do
        "" -> nil
        pitcher_type -> String.to_atom(pitcher_type)
      end
  })
end)

# "/Users/rodolfo/Code/Personal/BaseballDigitalManager/baseball_digital_manager/priv/repo/players.csv"
# |> File.stream!()
# |> CSV.decode(headers: true)
# |> Enum.map(fn data -> data end)
# |> Enum.map(fn {:ok, row} ->
#   IO.inspect(row, label: "// row //")

#   BaseballDigitalManager.Repo.insert!(%Player{
#     last_name: row["last_name"],
#     first_name: row["first_name"],
#     bats: String.to_atom(row["bats"]),
#     throws: String.to_atom(row["throws"]),
#     team_id: String.to_integer(row["team_id"]),
#     main_position: String.to_atom(row["main_position"]),
#     pitcher_type:
#       case row["pitcher_type"] do
#         "" -> nil
#         pitcher_type -> String.to_atom(pitcher_type)
#       end
#   })
# end)
