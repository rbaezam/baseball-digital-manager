defmodule BaseballDigitalManager.Games.GamePitchingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_pitching_stats" do
    field :balks, :integer, default: 0
    field :base_on_balls, :integer, default: 0
    field :batters_faced, :integer, default: 0
    field :closed_game, :boolean, default: false
    field :earned_runs, :integer, default: 0
    field :hits, :integer, default: 0
    field :lost_game, :boolean, default: false
    field :outs_pitched, :integer, default: 0
    field :runs, :integer, default: 0
    field :saved_game, :boolean, default: false
    field :started_game, :boolean, default: false
    field :strikeouts, :integer, default: 0
    field :wild_pitches, :integer, default: 0
    field :homeruns_allowed, :integer, default: 0
    field :won_game, :boolean, default: false
    field :hits_by_pitch, :integer, default: 0
    field :game_player_id, :id
    field :intentional_base_on_balls, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(pitching_stats, attrs) do
    pitching_stats
    |> cast(attrs, [
      :outs_pitched,
      :batters_faced,
      :hits,
      :runs,
      :earned_runs,
      :base_on_balls,
      :strikeouts,
      :wild_pitches,
      :balks,
      :started_game,
      :closed_game,
      :won_game,
      :lost_game,
      :saved_game,
      :homeruns_allowed,
      :game_player_id,
      :hits_by_pitch,
      :intentional_base_on_balls
    ])
    |> validate_required([
      :outs_pitched,
      :batters_faced,
      :hits,
      :runs,
      :earned_runs,
      :base_on_balls,
      :strikeouts,
      :wild_pitches,
      :balks,
      :started_game,
      :closed_game,
      :won_game,
      :lost_game,
      :saved_game
    ])
  end
end
