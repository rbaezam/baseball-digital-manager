defmodule BaseballDigitalManager.Teams.LineupItem do
  use Ecto.Schema
  import Ecto.Changeset

  schema "team_lineup_items" do
    field :bats, :string
    field :full_name, :string
    field :order, :integer

    field :position, Ecto.Enum,
      values: [
        :pitcher,
        :catcher,
        :firstbaseman,
        :secondbaseman,
        :thirdbaseman,
        :shortstop,
        :leftfielder,
        :centerfielder,
        :rightfielder,
        :infielder,
        :outfielder,
        :designated_hitter
      ]

    belongs_to :lineup, BaseballDigitalManager.Teams.Lineup
    belongs_to :player, BaseballDigitalManager.Players.Player

    timestamps()
  end

  @doc false
  def changeset(lineup_item, attrs) do
    lineup_item
    |> cast(attrs, [:order, :position, :full_name, :bats, :lineup_id, :player_id])
    |> validate_required([:order, :position, :full_name, :bats, :player_id])
  end
end
