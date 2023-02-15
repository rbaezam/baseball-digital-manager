defmodule BaseballDigitalManagerWeb.LibraryLive.Index do
  use BaseballDigitalManagerWeb, :live_view
  # use Phoenix.LiveView

  alias BaseballDigitalManager.Stats
  alias BaseballDigitalManager.{Leagues, Libraries}

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    library = Libraries.get_library!(id)
    leagues = Leagues.get_leagues_from_library(id)

    homerun_leaders = Stats.homerun_leaders()

    strikeout_leaders = Stats.strikeout_leaders()

    assigns =
      socket
      |> assign(:library, library)
      |> assign(:leagues, leagues)
      |> assign(:homerun_leaders, homerun_leaders)
      |> assign(:strikeout_leaders, strikeout_leaders)

    {:ok, assigns}
  end
end
