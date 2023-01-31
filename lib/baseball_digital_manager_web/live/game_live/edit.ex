defmodule BaseballDigitalManagerWeb.GameLive.Edit do
  use BaseballDigitalManagerWeb, :live_view

  alias BaseballDigitalManager.Libraries
  alias BaseballDigitalManager.{Games, Players, Teams}

  @impl true
  def mount(%{"library_id" => library_id, "id" => game_id}, _params, socket) do
    game = Games.get!(game_id)
    library = Libraries.get_library!(library_id)

    visitor_players =
      game.players
      |> Enum.filter(&(&1.is_local_team == false))

    local_players =
      game.players
      |> Enum.filter(& &1.is_local_team)

    assigns =
      socket
      |> assign(:game, game)
      |> assign(:library, library)
      |> assign(:visitor_players, visitor_players)
      |> assign(:local_players, local_players)

    {:ok, assigns}
  end
end
