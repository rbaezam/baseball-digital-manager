defmodule BaseballDigitalManager.Stats.PitchingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pitching_stats" do
    field :balks, :integer, default: 0
    field :base_on_balls, :integer, default: 0
    field :batters_faced, :integer, default: 0
    field :closed_games, :integer, default: 0
    field :earned_runs_allowed, :integer, default: 0
    field :games, :integer, default: 0
    field :complete_games, :integer, default: 0
    field :games_started, :integer, default: 0
    field :hits_allowed, :integer, default: 0
    field :hits_by_pitch, :integer, default: 0
    field :homeruns_allowed, :integer, default: 0
    field :intentional_base_on_balls, :integer, default: 0
    field :outs_pitched, :integer, default: 0
    field :runs_allowed, :integer, default: 0
    field :saves, :integer, default: 0
    field :shared_shutouts, :integer, default: 0
    field :shutouts, :integer, default: 0
    field :strikeouts, :integer, default: 0
    field :wild_pitches, :integer, default: 0
    field :wins, :integer, default: 0
    field :losses, :integer, default: 0
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
      :closed_games,
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
      :batters_faced,
      :wins,
      :losses,
      :player_id,
      :team_id,
      :season_id
    ])
    |> validate_required([
      :games,
      :closed_games,
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
