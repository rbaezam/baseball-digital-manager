defmodule BaseballDigitalManager.Teams.TeamStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_stats" do
    field :losses, :integer
    field :wins, :integer
    belongs_to :team, BaseballDigitalManager.Teams.Team
    belongs_to :season, BaseballDigitalManager.Seasons.Season

    timestamps()
  end

  @doc false
  def changeset(team_stats, attrs) do
    team_stats
    |> cast(attrs, [:wins, :losses])
    |> validate_required([:wins, :losses])
  end
end
