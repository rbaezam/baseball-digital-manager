defmodule BaseballDigitalManager.Divisions.Division do
  use Ecto.Schema
  import Ecto.Changeset

  schema "divisions" do
    field :name, :string
    field :short_name, :string
    belongs_to :league, BaseballDigitalManager.Leagues.League
    has_many :teams, BaseballDigitalManager.Teams.Team

    timestamps()
  end

  @doc false
  def changeset(division, attrs) do
    division
    |> cast(attrs, [:name, :short_name, :league_id])
    |> validate_required([:name, :short_name])
  end
end
