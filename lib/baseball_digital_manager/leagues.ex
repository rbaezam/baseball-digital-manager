defmodule BaseballDigitalManager.Leagues do
  @moduledoc """
  The Leagues context.
  """

  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Repo

  alias BaseballDigitalManager.Leagues.League

  def get_leagues_from_library(library_id) do
    from(l in League, where: l.library_id == ^library_id)
    |> Repo.all()
    |> Repo.preload(divisions: [:teams])
  end
end
