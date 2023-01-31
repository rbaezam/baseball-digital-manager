defmodule BaseballDigitalManager.Games.GameFieldingStats do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_fielding_stats" do
    field :assists, :integer
    field :errors, :integer
    field :passballs, :integer
    field :putouts, :integer
    field :game_player_id, :id

    timestamps()
  end

  @doc false
  def changeset(fielding_stats, attrs) do
    fielding_stats
    |> cast(attrs, [:putouts, :assists, :errors, :passballs])
    |> validate_required([:putouts, :assists, :errors, :passballs])
  end
end
