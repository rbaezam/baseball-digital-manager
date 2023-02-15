defmodule BaseballDigitalManager.Players.Player do
  use Ecto.Schema
  import Ecto.Changeset

  schema "players" do
    field :date_of_birth, :date
    field :debut_date, :date
    field :first_name, :string
    field :height, :integer
    field :last_name, :string
    field :place_of_birth, :string
    field :bats, Ecto.Enum, values: [:right, :left, :switch]
    field :throws, Ecto.Enum, values: [:right, :left]
    field :weight, :integer
    field :lineup_position, :integer, default: 0

    field :main_position, Ecto.Enum,
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

    field :secondary_position, Ecto.Enum,
      values: [
        :none,
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

    field :pitcher_type, Ecto.Enum, values: [:starter, :reliever, :setup, :closer]
    belongs_to :team, BaseballDigitalManager.Teams.Team

    has_many :game_players, BaseballDigitalManager.Games.GamePlayer
    has_many :batting_stats, BaseballDigitalManager.Stats.BattingStats
    has_many :pitching_stats, BaseballDigitalManager.Stats.PitchingStats
    has_many :fielding_stats, BaseballDigitalManager.Stats.FieldingStats

    has_many :game_batting_stats,
      through: [:game_players, :batting_stats]

    has_many :game_pitching_stats,
      through: [:game_players, :pitching_stats]

    timestamps()
  end

  @doc false
  def changeset(player, attrs) do
    player
    |> cast(attrs, [
      :last_name,
      :first_name,
      :bats,
      :throws,
      :height,
      :weight,
      :date_of_birth,
      :place_of_birth,
      :debut_date,
      :main_position,
      :pitcher_type,
      :team_id,
      :lineup_position
    ])
    |> validate_required([
      :last_name,
      :first_name,
      :bats,
      :throws,
      :height,
      :weight,
      :date_of_birth,
      :place_of_birth,
      :debut_date
    ])
  end
end
