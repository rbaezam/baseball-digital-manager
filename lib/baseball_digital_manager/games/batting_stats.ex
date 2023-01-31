defmodule BaseballDigitalManager.Games.GameBattingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_batting_stats" do
    field :at_bats, :integer
    field :base_on_balls, :integer
    field :caught_stealing, :integer
    field :doubles, :integer
    field :gidp, :integer
    field :hbp, :integer
    field :hits, :integer
    field :homeruns, :integer
    field :rbis, :integer
    field :runs, :integer
    field :sacrifice_flies, :integer
    field :sacrifice_hits, :integer
    field :stolen_bases, :integer
    field :strikeouts, :integer
    field :triples, :integer
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
      :hbp
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
