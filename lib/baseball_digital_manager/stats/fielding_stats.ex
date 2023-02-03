defmodule BaseballDigitalManager.Stats.FieldingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fielding_stats" do
    field :assists, :integer, default: 0
    field :caught_stealing, :integer, default: 0
    field :complete_games, :integer, default: 0
    field :defensive_chances, :integer, default: 0
    field :double_plays, :integer, default: 0
    field :errors, :integer, default: 0
    field :games, :integer, default: 0
    field :games_started, :integer, default: 0
    field :inning_played_in_field, :integer, default: 0
    field :passed_balls, :integer, default: 0
    field :pickoffs, :integer, default: 0
    field :putouts, :integer, default: 0
    field :stolen_bases_allowed, :integer, default: 0
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
