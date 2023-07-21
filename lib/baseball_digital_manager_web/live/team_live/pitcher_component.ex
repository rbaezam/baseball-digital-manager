defmodule BaseballDigitalManagerWeb.TeamLive.PitcherComponent do
  use BaseballDigitalManagerWeb, :live_component

  @impl true
  def update(assigns, socket) do
    pitcher_types = get_pitcher_types()
    bats_options = get_bats_options()
    throws_options = get_throws_options()

    assigns =
      socket
      |> assign(
        pitcher_types: pitcher_types,
        bats_options: bats_options,
        throws_options: throws_options,
        new_pitcher: assigns.new_pitcher,
        library_id: assigns.library_id,
        team: assigns.team
      )

    {:ok, assigns}
  end

  defp get_pitcher_types() do
    [
      Starter: :starter,
      Reliever: :reliever,
      Closer: :closer
    ]
  end

  defp get_bats_options() do
    [
      R: :right,
      S: :switch,
      L: :left
    ]
  end

  defp get_throws_options() do
    [
      R: :right,
      L: :left
    ]
  end
end
