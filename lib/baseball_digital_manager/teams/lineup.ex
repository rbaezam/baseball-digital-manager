defmodule BaseballDigitalManager.Teams.Lineup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_lineups" do
    field :name, :string
    belongs_to :team, BaseballDigitalManager.Teams.Team

    has_many :items, BaseballDigitalManager.Teams.LineupItem

    timestamps()
  end

  @doc false
  def changeset(lineup, attrs) do
    lineup
    |> cast(attrs, [:name, :team_id])
    |> cast_assoc(:items)
    |> validate_required([:name, :team_id])
  end
end
