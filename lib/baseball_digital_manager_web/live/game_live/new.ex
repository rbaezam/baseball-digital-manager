defmodule BaseballDigitalManagerWeb.GameLive.New do
  alias BaseballDigitalManager.Seasons
  alias BaseballDigitalManager.{Players, Teams}
  use BaseballDigitalManagerWeb, :live_view

  alias BaseballDigitalManager.Games

  @impl true
  def mount(
        %{
          "library_id" => library_id,
          "game_id" => game_id
        },
        _params,
        socket
      ) do
    teams =
      Teams.get_teams_from_library(library_id)
      |> Enum.map(&{&1.nick_name, &1.id})

    lineup_positions = ["", 1, 2, 3, 4, 5, 6, 7, 8, 9]

    season = Seasons.get_season_by_library_id(library_id)
    game = Games.get!(game_id, season)

    visitor_players =
      Players.get_players_from_team(game.visitor_team_id, season.id)
      |> Enum.map(fn item -> item |> Map.put(:is_selected, false) end)

    local_players =
      Players.get_players_from_team(game.local_team_id, season.id)
      |> Enum.map(fn item -> item |> Map.put(:is_selected, false) end)

    game_form = %{
      local_team: ""
    }

    assigns =
      socket
      |> assign(:library_id, library_id)
      |> assign(:current_date, game.date)
      |> assign(:teams, teams)
      |> assign(:game_form, game_form)
      |> assign(:selected_local_team, game.local_team_id)
      |> assign(:selected_visitor_team, game.visitor_team_id)
      |> assign(:visitor_players, visitor_players)
      |> assign(:local_players, local_players)
      |> assign(:lineup_positions, lineup_positions)
      |> assign(:game_id, game_id)
      |> assign(:season_id, season.id)

    {:ok, assigns}
  end

  def mount(%{"library_id" => library_id}, _params, socket) do
    teams =
      Teams.get_teams_from_library(library_id)
      |> Enum.map(&{&1.nick_name, &1.id})

    lineup_positions = ["", 1, 2, 3, 4, 5, 6, 7, 8, 9]

    visitor_players = []
    local_players = []

    game_form = %{
      local_team: ""
    }

    season = Seasons.get_season_by_library_id(library_id) |> IO.inspect(label: "-- seasons ---")

    assigns =
      socket
      |> assign(:library_id, library_id)
      |> assign(:teams, teams)
      |> assign(:game_form, game_form)
      |> assign(:selected_local_team, "")
      |> assign(:selected_visitor_team, "")
      |> assign(:visitor_players, visitor_players)
      |> assign(:local_players, local_players)
      |> assign(:lineup_positions, lineup_positions)
      |> assign(:season_id, season.id)

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
    game = Games.get!(socket.assigns.game_id)

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

    game = Games.update_game(game, attr)

    {:noreply,
     socket
     |> put_flash(:info, "Game created.")
     |> push_redirect(to: ~p"/game/#{socket.assigns.library_id}/edit/#{game.id}")}
  end

  def handle_event("change-visitor-team", %{"game_form" => form}, socket) do
    team_id = String.to_integer(form["visitor_team"])

    visitor_players =
      case team_id do
        "" ->
          []

        visitor_id ->
          Players.get_players_from_team(visitor_id, socket.assigns.season_id)
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
          Players.get_players_from_team(local_id, socket.assigns.season_id)
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

  def handle_event(
        "change-visitor-lineup-position",
        %{"id" => player_id, "value" => lineup_position},
        socket
      ) do
    visitor_players =
      socket.assigns.visitor_players
      |> Enum.map(fn item ->
        if item.id == String.to_integer(player_id) do
          lineup_position =
            case Integer.parse(lineup_position) do
              :error -> 0
              {lineup_position, _} -> lineup_position
            end

          item |> Map.put(:lineup_position, lineup_position)
        else
          item
        end
      end)

    assigns = socket |> assign(:visitor_players, visitor_players)
    {:noreply, assigns}
  end

  def handle_event(
        "change-local-lineup-position",
        %{"id" => player_id, "value" => lineup_position},
        socket
      ) do
    local_players =
      socket.assigns.local_players
      |> Enum.map(fn item ->
        if item.id == String.to_integer(player_id) do
          item |> Map.put(:lineup_position, String.to_integer(lineup_position))
        else
          item
        end
      end)

    assigns = socket |> assign(:local_players, local_players)
    {:noreply, assigns}
  end
end
