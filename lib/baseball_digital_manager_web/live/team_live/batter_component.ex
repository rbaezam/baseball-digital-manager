defmodule BaseballDigitalManagerWeb.TeamLive.BatterComponent do
  use BaseballDigitalManagerWeb, :live_component

  @impl true
  def update(assigns, socket) do
    IO.inspect(assigns, label: "** update assigns **")
    positions = get_positions()
    bats_options = get_bats_options()
    throws_options = get_throws_options()

    assigns =
      socket
      |> assign(
        positions: positions,
        bats_options: bats_options,
        throws_options: throws_options,
        new_batter: assigns.new_batter,
        library_id: assigns.library_id,
        team: assigns.team
      )

    {:ok, assigns}
  end

  defp get_positions() do
    [
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
