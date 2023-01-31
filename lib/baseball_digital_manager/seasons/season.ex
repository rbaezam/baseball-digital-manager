defmodule BaseballDigitalManager.Seasons.Season do
  use Ecto.Schema
  import Ecto.Changeset

  schema "seasons" do
    field :name, :string
    field :year, :integer
    belongs_to :library, BaseballDigitalManager.Libraries.Library

    timestamps()
  end

  @doc false
  def changeset(season, attrs) do
    season
    |> cast(attrs, [:library_id, :name, :year])
    |> validate_required([:name, :year])
  end
end
