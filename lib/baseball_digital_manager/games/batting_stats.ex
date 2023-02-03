defmodule BaseballDigitalManager.Games.GameBattingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_batting_stats" do
    field :at_bats, :integer, default: 0
    field :base_on_balls, :integer, default: 0
    field :intentional_base_on_balls, :integer, default: 0
    field :caught_stealing, :integer, default: 0
    field :doubles, :integer, default: 0
    field :gidp, :integer, default: 0
    field :hbp, :integer, default: 0
    field :hits, :integer, default: 0
    field :homeruns, :integer, default: 0
    field :rbis, :integer, default: 0
    field :runs, :integer, default: 0
    field :sacrifice_flies, :integer, default: 0
    field :sacrifice_hits, :integer, default: 0
    field :stolen_bases, :integer, default: 0
    field :strikeouts, :integer, default: 0
    field :triples, :integer, default: 0
    field :game_player_id, :id

    timestamps()
  end

  @doc false
  def changeset(batting_stats, attrs) do
    batting_stats
    |> cast(attrs, [
      :at_bats,
      :hits,
      :doubles,
      :triples,
      :homeruns,
      :runs,
      :rbis,
      :base_on_balls,
      :strikeouts,
      :stolen_bases,
      :caught_stealing,
      :sacrifice_hits,
      :sacrifice_flies,
      :gidp,
      :hbp,
      :game_player_id
    ])
    |> validate_required([
      :at_bats,
      :hits,
      :doubles,
      :triples,
      :homeruns,
      :runs,
      :rbis,
      :base_on_balls,
      :strikeouts,
      :stolen_bases,
      :caught_stealing,
      :sacrifice_hits,
      :sacrifice_flies,
      :gidp,
      :hbp
    ])
  end
end
