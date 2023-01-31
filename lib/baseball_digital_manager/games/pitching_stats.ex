defmodule BaseballDigitalManager.Games.GamePitchingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_pitching_stats" do
    field :balks, :integer
    field :base_on_balls, :integer
    field :batters_faced, :integer
    field :closed_game, :boolean, default: false
    field :earned_runs, :integer
    field :hits, :integer
    field :lost_game, :boolean, default: false
    field :outs_pitched, :integer
    field :runs, :integer
    field :saved_game, :boolean, default: false
    field :started_game, :boolean, default: false
    field :strikeouts, :integer
    field :wild_pitches, :integer
    field :won_game, :boolean, default: false
    field :game_player_id, :id

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
      :saved_game
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
