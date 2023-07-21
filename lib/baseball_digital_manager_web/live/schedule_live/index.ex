defmodule BaseballDigitalManagerWeb.ScheduleLive.Index do
  use BaseballDigitalManagerWeb, :live_view

  alias Timex.Duration
  alias BaseballDigitalManager.Games
  alias BaseballDigitalManager.Libraries

  @impl true
  def mount(%{"library_id" => library_id}, _session, socket) do
    library = Libraries.get_library!(library_id)
    tomorrow = Timex.add(library.current_date, Duration.from_days(1))

    todays_games =
      Games.get_games(library)
      |> Enum.map(fn game ->
        if game.is_completed do
          winner = Games.get_winner_pitcher(game)

          winner =
            winner
            |> Map.put(:wins, List.first(winner.player.pitching_stats).wins)
            |> Map.put(:loses, List.first(winner.player.pitching_stats).losses)

          loser = Games.get_loser_pitcher(game)

          loser =
            loser
            |> Map.put(:wins, List.first(loser.player.pitching_stats).wins)
            |> Map.put(:loses, List.first(loser.player.pitching_stats).losses)

          game
          |> Map.put(:pitcher_winner, winner)
          |> Map.put(:pitcher_loser, loser)
        else
          game
        end
      end)

    coming_games = Games.get_games(library, tomorrow)

    assigns =
      socket
      |> assign(:library, library)
      |> assign(:todays_games, todays_games)
      |> assign(:coming_games, coming_games)

    {:ok, assigns}
  end
end
