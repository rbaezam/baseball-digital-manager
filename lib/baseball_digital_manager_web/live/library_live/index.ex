defmodule BaseballDigitalManagerWeb.LibraryLive.Index do
  use BaseballDigitalManagerWeb, :live_view
  # use Phoenix.LiveView

  alias BaseballDigitalManager.Stats
  alias BaseballDigitalManager.{Leagues, Libraries}

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    library = Libraries.get_library!(id)
    leagues = Leagues.get_leagues_from_library(id)

    homerun_leaders = Stats.homerun_leaders(library)
    rbi_leaders = Stats.rbis_leaders(library)
    runs_leaders = Stats.runs_leaders(library)
    hits_leaders = Stats.hits_leaders(library)
    stolen_bases_leaders = Stats.stolen_bases_leaders(library)

    strikeout_leaders = Stats.strikeout_leaders(library)
    wins_leaders = Stats.wins_leaders(library)
    innings_pitched_leaders = Stats.innings_pitched_leaders(library)

    assigns =
      socket
      |> assign(:library, library)
      |> assign(:leagues, leagues)
      |> assign(:homerun_leaders, homerun_leaders)
      |> assign(:rbi_leaders, rbi_leaders)
      |> assign(:runs_leaders, runs_leaders)
      |> assign(:hits_leaders, hits_leaders)
      |> assign(:stolen_bases_leaders, stolen_bases_leaders)
      |> assign(:strikeout_leaders, strikeout_leaders)
      |> assign(:wins_leaders, wins_leaders)
      |> assign(:innings_pitched_leaders, innings_pitched_leaders)

    {:ok, assigns}
  end
end
