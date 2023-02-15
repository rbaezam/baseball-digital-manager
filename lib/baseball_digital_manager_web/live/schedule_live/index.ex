defmodule BaseballDigitalManagerWeb.ScheduleLive.Index do
  use BaseballDigitalManagerWeb, :live_view

  alias Timex.Duration
  alias BaseballDigitalManager.Games
  alias BaseballDigitalManager.Libraries

  @impl true
  def mount(%{"library_id" => library_id}, _session, socket) do
    library = Libraries.get_library!(library_id)
    tomorrow = Timex.add(library.current_date, Duration.from_days(1))
    todays_games = Games.get_games(library.current_date)
    coming_games = Games.get_games(tomorrow)

    assigns =
      socket
      |> assign(:library, library)
      |> assign(:todays_games, todays_games)
      |> assign(:coming_games, coming_games)

    {:ok, assigns}
  end
end
