defmodule BaseballDigitalManagerWeb.GameLive.Play do
  use BaseballDigitalManagerWeb, :live_view

  alias BaseballDigitalManager.{Games, Seasons}

  @impl true
  def mount(%{"library_id" => library_id, "id" => game_id}, _params, socket) do
    season = Seasons.get_season_by_library_id(library_id)

    game = Games.get!(game_id, season.id)

    initial_stats = %{at_bats: 0, hits: 0, runs: 0, homeruns: 0, rbis: 0, stolen_bases: 0}

    visitor_players =
      game.players
      |> Enum.filter(&(&1.main_position != "pitcher"))
      |> Enum.sort_by(& &1.lineup_position)
      |> Enum.map(fn item -> Map.merge(item, initial_stats) end)
      |> List.first()
      |> IO.inspect(label: "-- players --")

    visitor_pitchers =
      game.players
      |> Enum.filter(&(&1.main_position == "pitcher"))

    local_players =
      game.players
      |> Enum.filter(&(&1.main_position != "pitcher"))
      |> Enum.sort_by(& &1.lineup_position)
      |> Enum.map(fn item -> Map.merge(item, initial_stats) end)

    local_pitchers =
      game.players
      |> Enum.filter(&(&1.main_position == "pitcher"))

    current_visitor_pitcher = List.first(visitor_pitchers)
    current_local_pitcher = List.first(local_pitchers)
    current_local_batter = List.first(local_players)
    current_visitor_batter = List.first(visitor_players)

    assigns =
      socket
      |> assign(:game, game)
      |> assign(:current_batting_team, game.visitor_team)
      |> assign(:current_batting_players, visitor_players)
      |> assign(:visitor_players, visitor_players)
      |> assign(:visitor_pitchers, visitor_pitchers)
      |> assign(:local_players, local_players)
      |> assign(:local_pitchers, local_pitchers)
      |> assign(:current_local_pitcher, current_local_pitcher)
      |> assign(:current_visitor_pitcher, current_visitor_pitcher)
      |> assign(:current_local_batter, current_local_batter)
      |> assign(:current_visitor_batter, current_visitor_batter)
      |> assign(:is_local_team_batting, false)
      |> assign(:local_lineup_position, 1)
      |> assign(:visitor_lineup_position, 1)
      |> assign(:outs, 0)

    {:ok, assigns}
  end

  @impl true
  def handle_event("enter-play", %{"play" => play}, socket) do
    current_batter = socket.assigns.current_batter

    next_lineup_position = get_next_lineup_position(current_batter)

    {updated_player, outs} = process_play(socket, current_batter, play)

    current_players =
      socket.assigns.current_batting_players
      |> Enum.map(fn item ->
        if item.id == updated_player.id do
          updated_player
        else
          item
        end
      end)

    {visitor_players, local_players} =
      if socket.assigns.is_local_team_batting do
        {socket.assigns.visitor_players, current_players}
      else
        {current_players, socket.assigns.local_players}
      end

    {current_batting_team, current_players, is_local_team_batting, outs} =
      if outs >= 3 do
        if socket.assigns.is_local_team_batting do
          {socket.assigns.game.visitor_team, visitor_players, false, 0}
        else
          {socket.assigns.game.local_team, local_players, true, 0}
        end
      else
        {socket.assigns.current_batting_team, current_players,
         socket.assigns.is_local_team_batting, outs}
      end

    current_batter =
      if is_local_team_batting do
        local_players
        |> Enum.find(&(&1.lineup_position == next_lineup_position))
      else
        visitor_players
        |> Enum.find(&(&1.lineup_position == next_lineup_position))
      end

    assigns =
      socket
      |> assign(:current_batter, current_batter)
      |> assign(:current_batting_team, current_batting_team)
      |> assign(:current_batting_players, current_players)
      |> assign(:is_local_team_batting, is_local_team_batting)
      |> assign(:visitor_players, visitor_players)
      |> assign(:local_players, local_players)
      |> assign(:outs, outs)

    {:noreply, assigns}
  end

  defp get_next_lineup_position(current_batter) do
    if current_batter.lineup_position + 1 > 9 do
      1
    else
      current_batter.lineup_position + 1
    end
  end

  defp process_play(socket, current_batter, play) do
    player =
      socket.assigns.visitor_players
      |> Enum.find(&(&1.id == current_batter.id))

    outs = socket.assigns.outs

    player = player |> Map.put(:at_bats, current_batter.at_bats + 1)

    {player, outs} =
      case play do
        "1b" ->
          {player |> Map.put(:hits, current_batter.hits + 1), outs}

        "k" ->
          {player, outs + 1}

        _ ->
          {player, outs}
      end

    {player, outs}
  end
end
