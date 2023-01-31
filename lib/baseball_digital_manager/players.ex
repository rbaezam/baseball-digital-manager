defmodule BaseballDigitalManager.Players do
  @moduledoc """
  The Players context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Players.Player

  def get_players_from_team(team_id) do
    IO.inspect(team_id, label: "/// team id ///")

    from(p in Player, where: p.team_id == ^team_id)
    |> Repo.all()
  end
end
