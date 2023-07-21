defmodule BaseballDigitalManager.Seasons do
  import Ecto.Query, warn: false
  alias BaseballDigitalManager.Seasons.Season
  alias BaseballDigitalManager.Repo

  def get_season_by_library_id(library_id) do
    from(s in Season, where: s.library_id == ^library_id) |> Repo.one!()
  end
end
