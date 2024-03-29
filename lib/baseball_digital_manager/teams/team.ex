defmodule BaseballDigitalManager.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :nick_name, :string
    field :short_name, :string
    field :current_season_wins, :integer
    field :current_season_losses, :integer
    belongs_to :league, BaseballDigitalManager.Leagues.League
    belongs_to :division, BaseballDigitalManager.Divisions.Division
    belongs_to :season, BaseballDigitalManager.Seasons.Season

    has_many :players, BaseballDigitalManager.Players.Player
    has_many :stats, BaseballDigitalManager.Teams.TeamStats

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [
      :name,
      :nick_name,
      :short_name,
      :league_id,
      :division_id,
      :season_id,
      :current_season_wins,
      :current_season_losses
    ])
    |> validate_required([:name, :nick_name, :short_name])
  end
end
