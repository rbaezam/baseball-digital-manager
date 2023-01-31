defmodule BaseballDigitalManagerWeb.TeamLive.Show do
  use BaseballDigitalManagerWeb, :live_view

  alias BaseballDigitalManager.Teams

  @impl true
  def mount(%{"library_id" => library_id, "id" => id}, _session, socket) do
    team = Teams.get_team!(id)

    assigns =
      socket
      |> assign(:team, team)
      |> assign(:library_id, library_id)

    {:ok, assigns}
  end
end
