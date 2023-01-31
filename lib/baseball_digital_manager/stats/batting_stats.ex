defmodule BaseballDigitalManager.Stats.BattingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "batting_stats" do
    field :at_bats, :integer
    field :base_on_balls, :integer
    field :caught_stealing, :integer
    field :doubles, :integer
    field :games, :integer
    field :grounded_into_doubleplays, :integer
    field :hit_by_pitch, :integer
    field :hits, :integer
    field :homeruns, :integer
    field :intentional_base_on_balls, :integer
    field :plate_appearances, :integer
    field :rbis, :integer
    field :runs, :integer
    field :sacrifice_flies, :integer
    field :sacrifice_hits, :integer
    field :stolen_bases, :integer
    field :strikeouts, :integer
    field :triples, :integer
    belongs_to :player, BaseballDigitalManager.Players.Player
    belongs_to :team, BaseballDigitalManager.Teams.Team
    belongs_to :season, BaseballDigitalManager.Seasons.Season

    timestamps()
  end

  @doc false
  def changeset(batting_stats, attrs) do
    batting_stats
    |> cast(attrs, [:games, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :homeruns, :rbis, :stolen_bases, :caught_stealing, :base_on_balls, :strikeouts, :grounded_into_doubleplays, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :intentional_base_on_balls])
    |> validate_required([:games, :plate_appearances, :at_bats, :runs, :hits, :doubles, :triples, :homeruns, :rbis, :stolen_bases, :caught_stealing, :base_on_balls, :strikeouts, :grounded_into_doubleplays, :hit_by_pitch, :sacrifice_hits, :sacrifice_flies, :intentional_base_on_balls])
  end
end
