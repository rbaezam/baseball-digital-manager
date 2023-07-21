defmodule BaseballDigitalManagerWeb.GameLive.Edit do
  use BaseballDigitalManagerWeb, :live_view

  alias BaseballDigitalManager.{Games, Libraries, Seasons, Teams}

  @impl true
  def mount(%{"library_id" => library_id, "id" => game_id}, _params, socket) do
    season = Seasons.get_season_by_library_id(library_id)
    game = Games.get!(game_id, season.id)
    library = Libraries.get_library!(library_id)

    visitor_players =
      game.players
      |> Enum.filter(&(&1.is_local_team == false && &1.position != :pitcher))
      |> Enum.sort_by(& &1.lineup_position, :asc)
      |> set_stats_for_batters()

    visitor_pitchers =
      game.players
      |> Enum.filter(&(&1.is_local_team == false && &1.position == :pitcher))
      |> set_stats_for_pitchers()

    local_players =
      game.players
      |> Enum.filter(&(&1.is_local_team && &1.position != :pitcher))
      |> Enum.sort_by(& &1.lineup_position, :asc)
      |> set_stats_for_batters()

    local_pitchers =
      game.players
      |> Enum.filter(&(&1.is_local_team && &1.position == :pitcher))
      |> set_stats_for_pitchers()

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
      |> assign(
        game: game,
        library: library,
        visitor_players: visitor_players,
        visitor_pitchers: visitor_pitchers,
        local_players: local_players,
        local_pitchers: local_pitchers,
        positions: positions,
        visitor_hits: 0,
        visitor_runs: 0,
        visitor_errors: 0,
        visitor_lob: 0,
        local_hits: 0,
        local_runs: 0,
        local_errors: 0,
        local_lob: 0
      )

    {:ok, assigns}
  end

  @impl true
  def handle_event("validate-form", _params, socket) do
    # IO.inspect(params, label: "// validate form //")
    {:noreply, socket}
  end

  def handle_event("save-game", params, socket) do
    IO.inspect(params, label: "// save game //")
    game = socket.assigns.game

    visitor_runs = socket.assigns.visitor_runs
    local_runs = socket.assigns.local_runs

    attrs = %{
      visitor_runs: visitor_runs,
      local_runs: local_runs,
      visitor_hits: socket.assigns.visitor_hits,
      local_hits: socket.assigns.local_hits,
      local_errors: socket.assigns.local_errors,
      visitor_errors: socket.assigns.visitor_errors,
      visitor_lob: 0,
      local_lob: 0,
      is_completed: true
    }

    {team_winner, team_loser} =
      if visitor_runs > local_runs do
        {game.visitor_team_id, game.local_team_id}
      else
        {game.local_team_id, game.visitor_team_id}
      end

    Teams.add_game_win(team_winner)
    Teams.add_game_lost(team_loser)

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

    socket = update_visitor_team_stat(stat, socket)

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

    socket = update_visitor_team_stat(stat, socket)

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

    socket = update_local_team_stat(stat, socket)

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

    socket = update_local_team_stat(stat, socket)

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

  defp update_visitor_team_stat("hits", socket) do
    hits =
      socket.assigns.game.players
      |> Enum.filter(&(&1.is_local_team == false && &1.position != :pitcher))
      |> Enum.reduce(0, fn player, hits ->
        player.batting_stats.hits + hits
      end)

    IO.inspect(hits, label: "// visitor hits //")

    assign(socket, visitor_hits: hits)
  end

  defp update_visitor_team_stat("runs", socket) do
    runs =
      socket.assigns.game.players
      |> Enum.filter(&(&1.is_local_team == false && &1.position != :pitcher))
      |> Enum.reduce(0, fn player, runs ->
        player.batting_stats.runs + runs
      end)

    assign(socket, visitor_runs: runs)
  end

  defp update_visitor_team_stat("errors", socket) do
    errors =
      socket.assigns.game.players
      |> Enum.filter(&(&1.is_local_team == false && &1.position != :pitcher))
      |> Enum.reduce(0, fn player, errors ->
        player.fielding_stats.errors + errors
      end)

    assign(socket, visitor_errors: errors)
  end

  defp update_visitor_team_stat(_stat, socket), do: socket

  defp update_local_team_stat("hits", socket) do
    hits =
      socket.assigns.game.players
      |> Enum.filter(&(&1.is_local_team == true && &1.position != :pitcher))
      |> Enum.reduce(0, fn player, hits ->
        player.batting_stats.hits + hits
      end)

    assign(socket, local_hits: hits)
  end

  defp update_local_team_stat("runs", socket) do
    runs =
      socket.assigns.game.players
      |> Enum.filter(&(&1.is_local_team == true && &1.position != :pitcher))
      |> Enum.reduce(0, fn player, runs ->
        player.batting_stats.runs + runs
      end)

    assign(socket, local_runs: runs)
  end

  defp update_local_team_stat("errors", socket) do
    errors =
      socket.assigns.game.players
      |> Enum.filter(&(&1.is_local_team == true && &1.position != :pitcher))
      |> Enum.reduce(0, fn player, errors ->
        player.fielding_stats.errors + errors
      end)

    assign(socket, local_errors: errors)
  end

  defp update_local_team_stat(_stat, socket), do: socket

  defp set_stats_for_batters(batters) do
    batters
    |> Enum.map(fn item ->
      if item.batting_stats == nil do
        attrs = %{
          at_bats: 0,
          hits: 0,
          doubles: 0,
          triples: 0,
          homeruns: 0,
          runs: 0,
          rbis: 0,
          base_on_balls: 0,
          intentional_base_on_balls: 0,
          strikeouts: 0,
          stolen_bases: 0,
          caught_stealing: 0,
          sacrifice_hits: 0,
          sacrifice_flies: 0,
          gidp: 0,
          hbp: 0
        }

        Map.put(item, :batting_stats, attrs)
      else
        item
      end
    end)
    |> Enum.map(fn item ->
      if item.fielding_stats == nil do
        attrs = %{
          assists: 0,
          putouts: 0,
          errors: 0,
          passballs: 0
        }

        Map.put(item, :fielding_stats, attrs)
      else
        item
      end
    end)
  end

  defp set_stats_for_pitchers(pitchers) do
    pitchers
    |> Enum.map(fn item ->
      if item.pitching_stats == nil do
        attrs = %{
          outs_pitched: 0,
          batters_faced: 0,
          hits: 0,
          runs: 0,
          earned_runs: 0,
          homeruns_allowed: 0,
          base_on_balls: 0,
          strikeouts: 0,
          wild_pitches: 0,
          hits_by_pitch: 0,
          intentional_base_on_balls: 0,
          balks: 0,
          started_game: false,
          closed_game: false,
          won_game: false,
          lost_game: false,
          saved_game: false
        }

        Map.put(item, :pitching_stats, attrs)
      else
        item
      end
    end)
    |> Enum.map(fn item ->
      if item.fielding_stats == nil do
        attrs = %{
          assists: 0,
          putouts: 0,
          errors: 0,
          passballs: 0
        }

        Map.put(item, :fielding_stats, attrs)
      else
        item
      end
    end)
  end
end
