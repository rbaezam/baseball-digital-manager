defmodule BaseballDigitalManager.Teams do
  @moduledoc """
  The Teams context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Teams.Team

  def get_team!(id) do
    Repo.get!(Team, id)
  end

  def get_teams_from_library(library_id) do
    from(t in Team,
      join: league in assoc(t, :league),
      join: library in assoc(league, :library),
      where: library.id == ^library_id
    )
    |> Repo.all()
  end
end
