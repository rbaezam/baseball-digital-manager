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
      |> Enum.filter(&(&1.is_local_team == false && &1.position != "pitcher"))

    visitor_pitchers =
      game.players
      |> Enum.filter(&(&1.is_local_team == false && &1.position == "pitcher"))

    local_players =
      game.players
      |> Enum.filter(&(&1.is_local_team && &1.position != "pitcher"))

    local_pitchers =
      game.players
      |> Enum.filter(&(&1.is_local_team && &1.position == "pitcher"))

    positions = [
      C: :catcher,
      "1B": :firstbaseman,
      "2B": :secondbaseman,
      "3B": :thirdbaseman,
      SS: :shortstop,
      LF: :leftfielder,
      CF: :centerfielder,
      RF: :rightfielder,
      DH: :designated_hitter
    ]

    assigns =
      socket
      |> assign(:game, game)
      |> assign(:library, library)
      |> assign(:visitor_players, visitor_players)
      |> assign(:visitor_pitchers, visitor_pitchers)
      |> assign(:local_players, local_players)
      |> assign(:local_pitchers, local_pitchers)
      |> assign(:positions, positions)

    {:ok, assigns}
  end

  @impl true
  def handle_event("validate-form", _params, socket) do
    # IO.inspect(params, label: "// validate form //")
    {:noreply, socket}
  end

  def handle_event("save-game", params, socket) do
    IO.inspect(params, label: "// save game //")

    attrs = %{
      visitor_runs: String.to_integer(params["games-team-visitor-runs"]),
      local_runs: String.to_integer(params["games-team-local-runs"])
    }

    game =
      socket.assigns.game
      |> Games.update_game(attrs)

    assigns = socket |> assign(:game, game)

    {:noreply, assigns}
  end

  def handle_event("change-visitor-team-runs", %{"games-team-visitor-runs" => runs_str}, socket) do
    runs =
      if runs_str |> String.trim() |> String.length() > 0 do
        String.to_integer(runs_str)
      else
        0
      end

    game = Map.put(socket.assigns.game, :visitor_runs, runs)

    assigns =
      socket
      |> assign(:game, game)

    {:noreply, assigns}
  end

  def handle_event("change-local-team-runs", %{"games-team-local-runs" => runs_str}, socket) do
    runs =
      if runs_str |> String.trim() |> String.length() > 0 do
        String.to_integer(runs_str)
      else
        0
      end

    game = Map.put(socket.assigns.game, :local_runs, runs)

    assigns =
      socket
      |> assign(:game, game)

    {:noreply, assigns}
  end

  def handle_event(
        "change-visitor-batter-position",
        %{"id" => id, "value" => value},
        socket
      ) do
    int_id = String.to_integer(id)

    game_player =
      socket.assigns.visitor_players
      |> Enum.find(&(&1.id == int_id))

    Games.update_game_player(game_player, %{:position => value})

    game_player |> Map.put(:position, value)

    {:noreply, socket}
  end

  def handle_event(
        "change-visitor-batter-value",
        %{"id" => id, "stat" => stat, "value" => value},
        socket
      ) do
    stat_atom = String.to_atom(stat)
    int_value = String.to_integer(value)
    int_id = String.to_integer(id)

    game_player =
      socket.assigns.visitor_players
      |> Enum.find(&(&1.id == int_id))

    Games.update_batting_stats(game_player.batting_stats, %{:"#{stat}" => int_value})

    game_player.batting_stats |> Map.put(stat_atom, int_value)

    {:noreply, socket}
  end

  def handle_event(
        "change-visitor-pitching-value",
        %{"id" => id, "stat" => stat, "value" => value},
        socket
      ) do
    stat_atom = String.to_atom(stat)
    int_value = String.to_integer(value)
    int_id = String.to_integer(id)

    game_player =
      socket.assigns.visitor_pitchers
      |> Enum.find(&(&1.id == int_id))

    Games.update_pitching_stats(game_player.pitching_stats, %{:"#{stat}" => int_value})

    game_player.pitching_stats |> Map.put(stat_atom, int_value)

    {:noreply, socket}
  end

  def handle_event(
        "change-visitor-fielding-value",
        %{"id" => id, "stat" => stat, "value" => value},
        socket
      ) do
    stat_atom = String.to_atom(stat)
    int_value = String.to_integer(value)
    int_id = String.to_integer(id)

    game_player =
      (socket.assigns.visitor_players ++ socket.assigns.visitor_pitchers)
      |> Enum.find(&(&1.id == int_id))

    Games.update_fielding_stats(game_player.fielding_stats, %{:"#{stat}" => int_value})

    game_player.fielding_stats |> Map.put(stat_atom, int_value)

    {:noreply, socket}
  end

  def handle_event(
        "toggle-visitor-pitcher-value",
        %{"id" => id, "stat" => stat} = params,
        socket
      ) do
    stat_atom = String.to_atom(stat)

    value =
      if Map.has_key?(params, "value") do
        true
      else
        false
      end

    int_id = String.to_integer(id)

    game_player =
      socket.assigns.visitor_pitchers
      |> Enum.find(&(&1.id == int_id))

    Games.update_pitching_stats(game_player.pitching_stats, %{:"#{stat}" => value})

    game_player.pitching_stats |> Map.put(stat_atom, value)

    {:noreply, socket}
  end

  def handle_event(
        "change-local-batter-position",
        %{"id" => id, "value" => value},
        socket
      ) do
    int_id = String.to_integer(id)

    game_player =
      socket.assigns.local_players
      |> Enum.find(&(&1.id == int_id))

    Games.update_game_player(game_player, %{:position => value})

    game_player |> Map.put(:position, value)

    {:noreply, socket}
  end

  def handle_event(
        "change-local-batter-value",
        %{"id" => id, "stat" => stat, "value" => value},
        socket
      ) do
    stat_atom = String.to_atom(stat)
    int_value = String.to_integer(value)
    int_id = String.to_integer(id)

    game_player =
      socket.assigns.local_players
      |> Enum.find(&(&1.id == int_id))

    Games.update_batting_stats(game_player.batting_stats, %{:"#{stat}" => int_value})

    game_player.batting_stats |> Map.put(stat_atom, int_value)

    {:noreply, socket}
  end

  def handle_event(
        "change-local-pitching-value",
        %{"id" => id, "stat" => stat, "value" => value},
        socket
      ) do
    stat_atom = String.to_atom(stat)
    int_value = String.to_integer(value)
    int_id = String.to_integer(id)

    game_player =
      socket.assigns.local_pitchers
      |> Enum.find(&(&1.id == int_id))

    Games.update_pitching_stats(game_player.pitching_stats, %{:"#{stat}" => int_value})

    game_player.pitching_stats |> Map.put(stat_atom, int_value)

    {:noreply, socket}
  end

  def handle_event(
        "change-local-fielding-value",
        %{"id" => id, "stat" => stat, "value" => value},
        socket
      ) do
    stat_atom = String.to_atom(stat)
    int_value = String.to_integer(value)
    int_id = String.to_integer(id)

    game_player =
      (socket.assigns.local_players ++ socket.assigns.local_pitchers)
      |> Enum.find(&(&1.id == int_id))

    Games.update_fielding_stats(game_player.fielding_stats, %{:"#{stat}" => int_value})

    game_player.fielding_stats |> Map.put(stat_atom, int_value)

    {:noreply, socket}
  end

  def handle_event(
        "toggle-local-pitcher-value",
        %{"id" => id, "stat" => stat} = params,
        socket
      ) do
    stat_atom = String.to_atom(stat)

    value =
      if Map.has_key?(params, "value") do
        true
      else
        false
      end

    int_id = String.to_integer(id)

    game_player =
      socket.assigns.local_pitchers
      |> Enum.find(&(&1.id == int_id))

    Games.update_pitching_stats(game_player.pitching_stats, %{:"#{stat}" => value})

    game_player.pitching_stats |> Map.put(stat_atom, value)

    {:noreply, socket}
  end
end
