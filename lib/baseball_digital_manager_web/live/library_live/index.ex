defmodule BaseballDigitalManagerWeb.LibraryLive.Index do
  use BaseballDigitalManagerWeb, :live_view
  # use Phoenix.LiveView

  alias BaseballDigitalManager.{Leagues, Libraries}

  @impl true
  def mount(%{"id" => id} = _params, _session, socket) do
    library = Libraries.get_library!(id)
    leagues = Leagues.get_leagues_from_library(id)

    assigns =
      socket
      |> assign(:library, library)
      |> assign(:leagues, leagues)

    {:ok, assigns}
  end
end
