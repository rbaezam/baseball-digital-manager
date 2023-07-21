defmodule BaseballDigitalManagerWeb.TeamLive.Show do
  use BaseballDigitalManagerWeb, :live_view

  alias BaseballDigitalManager.{Players, Teams}

  @impl true
  def mount(
        %{
          "library_id" => library_id,
          "id" => id
        } = params,
        _session,
        socket
      ) do
    team = Teams.get_team!(id)

    sort_by = Map.get(params, "sort_by", "name")
    sort_direction = Map.get(params, "sort_direction", "asc")

    players = Players.get_players_from_team(team.id, team.season_id, sort_by, sort_direction)

    sort_direction =
      case sort_direction do
        "asc" -> "desc"
        "desc" -> "asc"
      end

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
      |> assign(:new_batter, %{})
      |> assign(:new_pitcher, %{})
      |> assign(:sort_direction, sort_direction)

    {:ok, assigns}
  end

  @impl true
  def handle_params(params, _url, socket) do
    sort_by = Map.get(params, "sort_by", "name")
    sort_direction = Map.get(params, "sort_direction", "asc")
    team = Teams.get_team!(socket.assigns.team.id)

    players = Players.get_players_from_team(team.id, team.season_id, sort_by, sort_direction)

    sort_direction =
      case sort_direction do
        "asc" -> "desc"
        "desc" -> "asc"
      end

    batters =
      players
      |> Enum.filter(&(&1.main_position != :pitcher))

    pitchers =
      players
      |> Enum.filter(&(&1.main_position == :pitcher))

    assigns =
      socket
      |> assign(:batters, batters)
      |> assign(:pitchers, pitchers)
      |> assign(:sort_direction, sort_direction)

    {:noreply, assigns}
  end

  @impl true
  def handle_event("select-player", %{"id" => id}, socket) do
    assigns =
      socket
      |> assign(:selected_player, String.to_integer(id))

    {:noreply, assigns}
  end

  def handle_event("show-modal-add-batter", _params, socket) do
    library_id = socket.assigns.library_id
    team = socket.assigns.team
    {:noreply, push_patch(socket, to: "/team/#{library_id}/#{team.id}/add-batter")}
  end

  def handle_event("validate-batter-form", params, socket) do
    IO.inspect(params, label: "// params in validate form //")
    {:noreply, socket}
  end

  def handle_event("save-batter-form", params, socket) do
    IO.inspect(params, label: "-- params --")
    library_id = socket.assigns.library_id
    team = socket.assigns.team

    params = Map.put(params, "team_id", team.id)
    Players.create_batter(params)

    batters =
      Players.get_players_from_team(team.id, team.season_id)
      |> Enum.filter(&(&1.main_position != :pitcher))

    assigns =
      socket
      |> assign(batters: batters)
      |> put_flash(:info, "Batter saved correctly!")
      |> push_patch(to: "/team/#{library_id}/#{team.id}")

    {:noreply, assigns}
  end

  def handle_event("show-modal-add-pitcher", _params, socket) do
    library_id = socket.assigns.library_id
    team = socket.assigns.team
    {:noreply, push_patch(socket, to: "/team/#{library_id}/#{team.id}/add-pitcher")}
  end

  def handle_event("validate-pitcher-form", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("save-pitcher-form", params, socket) do
    library_id = socket.assigns.library_id
    team = socket.assigns.team

    params = params |> Map.put("team_id", team.id) |> Map.put("main_position", :pitcher)
    IO.inspect(params, label: "// params in save pitcher form //")
    Players.create_pitcher(params)

    pitchers =
      Players.get_players_from_team(team.id, team.season_id)
      |> Enum.filter(&(&1.main_position == :pitcher))

    assigns =
      socket
      |> assign(pitchers: pitchers)
      |> put_flash(:info, "Pitcher saved correctly!")
      |> push_patch(to: "/team/#{library_id}/#{team.id}")

    {:noreply, assigns}
  end
end
