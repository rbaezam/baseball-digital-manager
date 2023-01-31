defmodule BaseballDigitalManager.Stats.PitchingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pitching_stats" do
    field :balks, :integer
    field :base_on_balls, :integer
    field :batters_faced, :integer
    field :closed_games, :integer
    field :earned_runs_allowed, :integer
    field :games, :integer
    field :games_finished, :integer
    field :games_started, :integer
    field :hits_allowed, :integer
    field :hits_by_pitch, :integer
    field :homeruns_allowed, :integer
    field :intentional_base_on_balls, :integer
    field :outs_pitched, :integer
    field :runs_allowed, :integer
    field :saves, :integer
    field :shared_shutouts, :integer
    field :shutouts, :integer
    field :strikeouts, :integer
    field :wild_pitches, :integer
    belongs_to :player, BaseballDigitalManager.Players.Player
    belongs_to :team, BaseballDigitalManager.Teams.Team
    belongs_to :season, BaseballDigitalManager.Seasons.Season

    timestamps()
  end

  @doc false
  def changeset(pitching_stats, attrs) do
    pitching_stats
    |> cast(attrs, [
      :player_id,
      :team_id,
      :season_id,
      :games,
      :games_finished,
      :games_started,
      :closed_games,
      :shutouts,
      :shared_shutouts,
      :saves,
      :outs_pitched,
      :hits_allowed,
      :runs_allowed,
      :earned_runs_allowed,
      :homeruns_allowed,
      :base_on_balls,
      :intentional_base_on_balls,
      :strikeouts,
      :hits_by_pitch,
      :balks,
      :wild_pitches,
      :batters_faced
    ])
    |> validate_required([
      :games,
      :games_finished,
      :games_started,
      :closed_games,
      :shutouts,
      :shared_shutouts,
      :saves,
      :outs_pitched,
      :hits_allowed,
      :runs_allowed,
      :earned_runs_allowed,
      :homeruns_allowed,
      :base_on_balls,
      :intentional_base_on_balls,
      :strikeouts,
      :hits_by_pitch,
      :balks,
      :wild_pitches,
      :batters_faced
    ])
  end
end
