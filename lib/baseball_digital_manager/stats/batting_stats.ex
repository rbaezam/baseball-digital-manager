defmodule BaseballDigitalManager.Stats.BattingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "batting_stats" do
    field :at_bats, :integer, default: 0
    field :base_on_balls, :integer, default: 0
    field :caught_stealing, :integer, default: 0
    field :doubles, :integer, default: 0
    field :games, :integer, default: 0
    field :grounded_into_doubleplays, :integer, default: 0
    field :hit_by_pitch, :integer, default: 0
    field :hits, :integer, default: 0
    field :homeruns, :integer, default: 0
    field :intentional_base_on_balls, :integer, default: 0
    field :plate_appearances, :integer, default: 0
    field :rbis, :integer, default: 0
    field :runs, :integer, default: 0
    field :sacrifice_flies, :integer, default: 0
    field :sacrifice_hits, :integer, default: 0
    field :stolen_bases, :integer, default: 0
    field :strikeouts, :integer, default: 0
    field :triples, :integer, default: 0
    belongs_to :player, BaseballDigitalManager.Players.Player
    belongs_to :team, BaseballDigitalManager.Teams.Team
    belongs_to :season, BaseballDigitalManager.Seasons.Season

    timestamps()
  end

  @doc false
  def changeset(batting_stats, attrs) do
    batting_stats
    |> cast(attrs, [
      :games,
      :plate_appearances,
      :at_bats,
      :runs,
      :hits,
      :doubles,
      :triples,
      :homeruns,
      :rbis,
      :stolen_bases,
      :caught_stealing,
      :base_on_balls,
      :strikeouts,
      :grounded_into_doubleplays,
      :hit_by_pitch,
      :sacrifice_hits,
      :sacrifice_flies,
      :intentional_base_on_balls,
      :player_id,
      :team_id,
      :season_id
    ])
    |> validate_required([
      :games,
      :plate_appearances,
      :at_bats,
      :runs,
      :hits,
      :doubles,
      :triples,
      :homeruns,
      :rbis,
      :stolen_bases,
      :caught_stealing,
      :base_on_balls,
      :strikeouts,
      :grounded_into_doubleplays,
      :hit_by_pitch,
      :sacrifice_hits,
      :sacrifice_flies,
      :intentional_base_on_balls
    ])
  end
end
