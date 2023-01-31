defmodule BaseballDigitalManagerWeb.GameLive.New do
  alias BaseballDigitalManager.{Players, Teams}
  use BaseballDigitalManagerWeb, :live_view

  alias BaseballDigitalManager.Games

  @impl true
  def mount(%{"library_id" => library_id}, _params, socket) do
    teams = Teams.get_teams_from_library(library_id) |> Enum.map(&{&1.name, &1.id})
    visitor_players = []
    local_players = []

    game_form = %{
      local_team: ""
    }

    assigns =
      socket
      |> assign(:library_id, library_id)
      |> assign(:teams, teams)
      |> assign(:game_form, game_form)
      |> assign(:selected_local_team, "")
      |> assign(:selected_visitor_team, "")
      |> assign(:visitor_players, visitor_players)
      |> assign(:local_players, local_players)

    {:ok, assigns}
  end

  @impl true
  def handle_event("validate-form", %{"game_form" => form}, socket) do
    visitor_team = form["visitor_team"]
    local_team = form["local_team"]

    assigns =
      socket
      |> assign(:selected_visitor_team, visitor_team)
      |> assign(:selected_local_team, local_team)

    {:noreply, assigns}
  end

  def handle_event("save-game", _params, socket) do
    IO.inspect(socket.assigns.library_id, label: "//// save game assigns ///")

    selected_visitor_players =
      socket.assigns.visitor_players
      |> Enum.filter(fn player ->
        player.is_selected
      end)
      |> Enum.map(fn player ->
        %{
          player_id: player.id,
          team_id: player.team_id,
          is_local_team: false,
          position: Atom.to_string(player.main_position)
        }
      end)

    selected_local_players =
      socket.assigns.local_players
      |> Enum.filter(fn player ->
        player.is_selected
      end)
      |> Enum.map(fn player ->
        %{
          player_id: player.id,
          team_id: player.team_id,
          is_local_team: true,
          position: Atom.to_string(player.main_position)
        }
      end)

    attr = %{
      players: selected_visitor_players ++ selected_local_players,
      visitor_team_id: socket.assigns.selected_visitor_team,
      local_team_id: socket.assigns.selected_local_team,
      library_id: socket.assigns.library_id
    }

    Games.create(attr)

    {:noreply, socket}
  end

  def handle_event("change-visitor-team", %{"game_form" => form}, socket) do
    team_id = String.to_integer(form["visitor_team"])

    visitor_players =
      case team_id do
        "" ->
          []

        visitor_id ->
          Players.get_players_from_team(visitor_id)
          |> Enum.map(fn item -> item |> Map.put(:is_selected, false) end)
      end

    assigns =
      socket
      |> assign(:visitor_players, visitor_players)
      |> assign(:selected_visitor_team, team_id)

    {:noreply, assigns}
  end

  def handle_event("change-local-team", %{"game_form" => form}, socket) do
    team_id = String.to_integer(form["local_team"])

    local_players =
      case team_id do
        "" ->
          []

        local_id ->
          Players.get_players_from_team(local_id)
          |> Enum.map(fn item -> item |> Map.put(:is_selected, false) end)
          |> IO.inspect(label: "// local players //")
      end

    assigns =
      socket
      |> assign(:local_players, local_players)
      |> assign(:selected_local_team, team_id)

    {:noreply, assigns}
  end

  def handle_event(
        "toggle-player",
        %{"value" => "true", "id" => player_id, "team" => "visitor"},
        socket
      ) do
    visitor_players =
      socket.assigns.visitor_players
      |> Enum.map(fn item ->
        if item.id == String.to_integer(player_id) do
          item |> Map.put(:is_selected, true)
        else
          item
        end
      end)

    assigns = socket |> assign(:visitor_players, visitor_players)
    {:noreply, assigns}
  end

  def handle_event(
        "toggle-player",
        %{"id" => player_id, "team" => "visitor"},
        socket
      ) do
    visitor_players =
      socket.assigns.visitor_players
      |> Enum.map(fn item ->
        if item.id == String.to_integer(player_id) do
          item |> Map.put(:is_selected, false)
        else
          item
        end
      end)

    assigns = socket |> assign(:visitor_players, visitor_players)
    {:noreply, assigns}
  end

  def handle_event(
        "toggle-player",
        %{"value" => "true", "id" => player_id, "team" => "local"},
        socket
      ) do
    local_players =
      socket.assigns.local_players
      |> Enum.map(fn item ->
        if item.id == String.to_integer(player_id) do
          item |> Map.put(:is_selected, true)
        else
          item
        end
      end)

    assigns = socket |> assign(:local_players, local_players)
    {:noreply, assigns}
  end

  def handle_event(
        "toggle-player",
        %{"id" => player_id, "team" => "local"},
        socket
      ) do
    local_players =
      socket.assigns.local_players
      |> Enum.map(fn item ->
        if item.id == String.to_integer(player_id) do
          item |> Map.put(:is_selected, false)
        else
          item
        end
      end)

    assigns = socket |> assign(:local_players, local_players)
    {:noreply, assigns}
  end
end
