defmodule BaseballDigitalManager.Stats.FieldingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fielding_stats" do
    field :assists, :integer
    field :caught_stealing, :integer
    field :complete_games, :integer
    field :defensive_chances, :integer
    field :double_plays, :integer
    field :errors, :integer
    field :games, :integer
    field :games_started, :integer
    field :inning_played_in_field, :integer
    field :passed_balls, :integer
    field :pickoffs, :integer
    field :putouts, :integer
    field :stolen_bases_allowed, :integer
    belongs_to :player, BaseballDigitalManager.Players.Player
    belongs_to :team, BaseballDigitalManager.Teams.Team
    belongs_to :season, BaseballDigitalManager.Seasons.Season

    timestamps()
  end

  @doc false
  def changeset(fielding_stats, attrs) do
    fielding_stats
    |> cast(attrs, [
      :player_id,
      :team_id,
      :season_id,
      :games,
      :games_started,
      :complete_games,
      :inning_played_in_field,
      :defensive_chances,
      :putouts,
      :assists,
      :errors,
      :double_plays,
      :passed_balls,
      :stolen_bases_allowed,
      :caught_stealing,
      :pickoffs
    ])
    |> validate_required([
      :games,
      :games_started,
      :complete_games,
      :inning_played_in_field,
      :defensive_chances,
      :putouts,
      :assists,
      :errors,
      :double_plays,
      :passed_balls,
      :stolen_bases_allowed,
      :caught_stealing,
      :pickoffs
    ])
  end
end
