defmodule BaseballDigitalManager.Games.GameFieldingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_fielding_stats" do
    field :assists, :integer, default: 0
    field :errors, :integer, default: 0
    field :passballs, :integer, default: 0
    field :putouts, :integer, default: 0
    field :game_player_id, :id

    timestamps()
  end

  @doc false
  def changeset(fielding_stats, attrs) do
    fielding_stats
    |> cast(attrs, [:putouts, :assists, :errors, :passballs, :game_player_id])
    |> validate_required([:putouts, :assists, :errors, :passballs])
  end
end
