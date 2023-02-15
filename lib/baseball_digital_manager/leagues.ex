defmodule BaseballDigitalManager.Leagues do
  @moduledoc """
  The Leagues context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Leagues.League
  alias BaseballDigitalManager.Teams.Team

  def get_leagues_from_library(library_id) do
    teams_query = from(t in Team, order_by: [desc: t.current_season_wins])

    from(l in League,
      where: l.library_id == ^library_id,
      preload: [divisions: [teams: ^teams_query]]
    )
    |> Repo.all()
  end
end
