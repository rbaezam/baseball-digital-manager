defmodule BaseballDigitalManagerWeb.TeamLive.Show do
  use BaseballDigitalManagerWeb, :live_view

  alias BaseballDigitalManager.{Players, Teams}

  @impl true
  def mount(%{"library_id" => library_id, "id" => id}, _session, socket) do
    team = Teams.get_team!(id)

    players = Players.get_players_from_team(team.id)

    batters =
      players
      |> Enum.filter(&(&1.main_position != :pitcher))

    pitchers =
      players
      |> Enum.filter(&(&1.main_position == :pitcher))

    assigns =
      socket
      |> assign(:team, team)
      |> assign(:library_id, library_id)
      |> assign(:batters, batters)
      |> assign(:pitchers, pitchers)
      |> assign(:selected_player, nil)

    {:ok, assigns}
  end

  @impl true
  def handle_event("select-player", %{"id" => id}, socket) do
    assigns =
      socket
      |> assign(:selected_player, String.to_integer(id))

    {:noreply, assigns}
  end
end
