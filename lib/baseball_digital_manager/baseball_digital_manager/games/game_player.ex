defmodule BaseballDigitalManager.Games.GamePlayer do
  use Ecto.Schema
  import Ecto.Changeset

  schema "game_players" do
    field :position, :string
    field :is_local_team, :boolean, default: false
    belongs_to :team, BaseballDigitalManager.Teams.Team
    belongs_to :game, BaseballDigitalManager.Games.Game
    belongs_to :player, BaseballDigitalManager.Players.Player

    has_one :batting_stats, BaseballDigitalManager.Games.GameBattingStats
    has_one :fielding_stats, BaseballDigitalManager.Games.GameFieldingStats
    has_one :pitching_stats, BaseballDigitalManager.Games.GamePitchingStats

    timestamps()
  end

  @doc false
  def changeset(game_player, attrs) do
    game_player
    |> cast(attrs, [:position, :game_id, :player_id, :is_local_team, :team_id])
    |> validate_required([:position, :player_id])
  end
end
