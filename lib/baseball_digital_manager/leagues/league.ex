defmodule BaseballDigitalManager.Leagues.League do
  use Ecto.Schema
  import Ecto.Changeset

  schema "leagues" do
    field :name, :string
    field :short_name, :string
    belongs_to :library, BaseballDigitalManager.Libraries.Library

    has_many :divisions, BaseballDigitalManager.Divisions.Division

    timestamps()
  end

  @doc false
  def changeset(league, attrs) do
    league
    |> cast(attrs, [:name, :short_name])
    |> validate_required([:name, :short_name])
  end
end
