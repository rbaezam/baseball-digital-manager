defmodule BaseballDigitalManagerWeb.GameLive.Setup do
  alias BaseballDigitalManager.{Games, Libraries, Players, Seasons, Teams}
  use BaseballDigitalManagerWeb, :live_view

  @impl true
  def mount(%{"library_id" => library_id, "id" => game_id}, _params, socket) do
    library = Libraries.get_library!(library_id)
    season = Seasons.get_season_by_library_id(library.id)
    game = Games.get!(game_id, season.id)

    visitor_saved_lineups =
      Teams.get_saved_lineups_for_team(game.visitor_team.id)
      |> Enum.map(&{&1.name, &1.id})

    visitor_players =
      Players.get_players_from_team(game.visitor_team_id, game.visitor_team.season_id)

    visitor_batters = visitor_players |> Enum.reject(&(&1.main_position == :pitcher))
    visitor_pitchers = visitor_players |> Enum.filter(&(&1.main_position == :pitcher))

    visitor_lineup_items = generate_initial_lineup()
    visitor_starting_pitcher = generate_default_starting_pitcher()

    local_saved_lineups =
      Teams.get_saved_lineups_for_team(game.local_team.id)
      |> Enum.map(&{&1.name, &1.id})

    local_players = Players.get_players_from_team(game.local_team_id, game.local_team.season_id)

    local_batters = local_players |> Enum.reject(&(&1.main_position == :pitcher))
    local_pitchers = local_players |> Enum.filter(&(&1.main_position == :pitcher))

    local_lineup_items = generate_initial_lineup()
    local_starting_pitcher = generate_default_starting_pitcher()

    assigns =
      assign(socket,
        game: game,
        library: library,
        library_id: library.id,
        active_tab: :visitor,
        visitor_saved_lineups: visitor_saved_lineups,
        visitor_selected_lineup: nil,
        visitor_batters: visitor_batters,
        visitor_pitchers: visitor_pitchers,
        visitor_lineup_items: visitor_lineup_items,
        visitor_starting_pitcher: visitor_starting_pitcher,
        visitor_selected_batter: nil,
        local_saved_lineups: local_saved_lineups,
        local_selected_lineup: nil,
        local_batters: local_batters,
        local_pitchers: local_pitchers,
        local_lineup_items: local_lineup_items,
        local_starting_pitcher: local_starting_pitcher,
        local_selected_batter: nil
      )

    {:ok, assigns}
  end

  @impl true
  def handle_event("change-tab", %{"tab" => "visitor"}, socket) do
    {:noreply, assign(socket, active_tab: :visitor)}
  end

  def handle_event("change-tab", %{"tab" => "local"}, socket) do
    {:noreply, assign(socket, active_tab: :local)}
  end

  def handle_event("save-visitor-lineup", _params, socket) do
    %{
      name: "test",
      team_id: socket.assigns.game.visitor_team_id,
      items: socket.assigns.visitor_lineup_items
    }
    |> Teams.save_lineup()

    visitor_saved_lineups =
      Teams.get_saved_lineups_for_team(socket.assigns.game.visitor_team_id)
      |> Enum.map(&{&1.name, &1.id})

    assigns =
      socket
      |> assign(visitor_saved_lineups: visitor_saved_lineups)
      |> put_flash(:info, "Lineup saved correctly!")

    {:noreply, assigns}
  end

  def handle_event("select-visitor-lineup", %{"visitor-lineup-select" => id}, socket) do
    selected_lineup = Teams.get_lineup!(id)
    visitor_lineup_items = selected_lineup.items

    assigns =
      socket
      |> assign(
        visitor_selected_lineup: selected_lineup.id,
        visitor_lineup_items: visitor_lineup_items
      )

    {:noreply, assigns}
  end

  def handle_event("select-visitor-batter", %{"id" => id}, socket) do
    selected_batter =
      socket.assigns.visitor_batters
      |> Enum.find(&(&1.id == String.to_integer(id)))

    {:noreply, assign(socket, visitor_selected_batter: selected_batter)}
  end

  def handle_event("assign-visitor-batter", %{"order" => order}, socket) do
    selected_batter = socket.assigns.visitor_selected_batter

    new_batter =
      if selected_batter != nil do
        %{
          player_id: selected_batter.id,
          order: String.to_integer(order),
          full_name: selected_batter.full_name,
          position: selected_batter.main_position,
          bats: selected_batter.bats
        }
      else
        %{
          player_id: nil,
          order: String.to_integer(order),
          full_name: "",
          position: "",
          bats: ""
        }
      end

    new_lineup =
      socket.assigns.visitor_lineup_items
      |> Enum.map(fn batter ->
        if batter.order == new_batter.order do
          new_batter
        else
          batter
        end
      end)

    {:noreply, assign(socket, visitor_lineup_items: new_lineup)}
  end

  def handle_event("select-visitor-starting-pitcher", %{"id" => id}, socket) do
    selected_pitcher =
      socket.assigns.visitor_pitchers
      |> Enum.find(&(&1.id == String.to_integer(id)))

    assigns = socket |> assign(visitor_starting_pitcher: selected_pitcher)
    {:noreply, assigns}
  end

  def handle_event("save-local-lineup", _params, socket) do
    %{
      name: "test",
      team_id: socket.assigns.game.local_team_id,
      items: socket.assigns.local_lineup_items
    }
    |> Teams.save_lineup()

    local_saved_lineups =
      Teams.get_saved_lineups_for_team(socket.assigns.game.local_team_id)
      |> Enum.map(&{&1.name, &1.id})

    assigns =
      socket
      |> assign(local_saved_lineups: local_saved_lineups)
      |> put_flash(:info, "Lineup saved correctly!")

    {:noreply, assigns}
  end

  def handle_event("select-local-lineup", %{"local-lineup-select" => id}, socket) do
    selected_lineup = Teams.get_lineup!(id)
    local_lineup_items = selected_lineup.items

    assigns =
      socket
      |> assign(
        local_selected_lineup: selected_lineup.id,
        local_lineup_items: local_lineup_items
      )

    {:noreply, assigns}
  end

  def handle_event("select-local-batter", %{"id" => id}, socket) do
    selected_batter =
      socket.assigns.local_batters
      |> Enum.find(&(&1.id == String.to_integer(id)))

    {:noreply, assign(socket, local_selected_batter: selected_batter)}
  end

  def handle_event("assign-local-batter", %{"order" => order}, socket) do
    selected_batter = socket.assigns.local_selected_batter

    new_batter =
      if selected_batter != nil do
        %{
          player_id: selected_batter.id,
          order: String.to_integer(order),
          full_name: selected_batter.full_name,
          position: selected_batter.main_position,
          bats: selected_batter.bats
        }
      else
        %{
          player_id: nil,
          order: String.to_integer(order),
          full_name: "",
          position: "",
          bats: ""
        }
      end

    new_lineup =
      socket.assigns.local_lineup_items
      |> Enum.map(fn batter ->
        if batter.order == new_batter.order do
          new_batter
        else
          batter
        end
      end)

    {:noreply, assign(socket, local_lineup_items: new_lineup)}
  end

  def handle_event("select-local-starting-pitcher", %{"id" => id}, socket) do
    selected_pitcher =
      socket.assigns.local_pitchers
      |> Enum.find(&(&1.id == String.to_integer(id)))

    assigns = socket |> assign(local_starting_pitcher: selected_pitcher)
    {:noreply, assigns}
  end

  def handle_event("play-game", _params, socket) do
    attrs = %{
      visitor_lineup: socket.assigns.visitor_lineup_items,
      local_lineup: socket.assigns.local_lineup_items,
      visitor_pitcher: socket.assigns.visitor_starting_pitcher,
      local_pitcher: socket.assigns.local_starting_pitcher
    }

    Games.setup_game(socket.assigns.game, attrs)

    {:noreply,
     socket
     |> push_redirect(to: ~p"/game/#{socket.assigns.library_id}/edit/#{socket.assigns.game.id}")}
  end

  defp generate_initial_lineup() do
    Enum.map(1..9, fn order ->
      %{
        player_id: nil,
        order: order,
        full_name: "",
        position: "",
        bats: ""
      }
    end)
  end

  defp generate_default_starting_pitcher() do
    %{
      id: 0,
      full_name: "",
      pitching_stats: %{
        wins: "",
        losses: ""
      }
    }
  end
end
