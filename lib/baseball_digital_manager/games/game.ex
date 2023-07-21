defmodule BaseballDigitalManager.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  alias BaseballDigitalManager.Games.GamePlayer

  schema "games" do
    field :date, :date, default: Date.utc_today()
    field :local_errors, :integer, default: 0
    field :local_hits, :integer, default: 0
    field :local_lob, :integer, default: 0
    field :local_runs, :integer, default: 0
    field :season, :integer, default: 0
    field :visitor_errors, :integer, default: 0
    field :visitor_hits, :integer, default: 0
    field :visitor_lob, :integer, default: 0
    field :visitor_runs, :integer, default: 0
    field :is_completed, :boolean
    belongs_to :library, BaseballDigitalManager.Libraries.Library
    belongs_to :visitor_team, BaseballDigitalManager.Teams.Team
    belongs_to :local_team, BaseballDigitalManager.Teams.Team

    has_many :players, BaseballDigitalManager.Games.GamePlayer

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [
      :season,
      :date,
      :visitor_runs,
      :local_runs,
      :visitor_hits,
      :local_hits,
      :visitor_errors,
      :local_errors,
      :visitor_lob,
      :local_lob,
      :library_id,
      :visitor_team_id,
      :local_team_id,
      :is_completed
    ])
    |> cast_assoc(:players, with: &GamePlayer.changeset/2)
    |> validate_required([
      :season,
      :date,
      :visitor_runs,
      :local_runs,
      :visitor_hits,
      :local_hits,
      :visitor_errors,
      :local_errors,
      :visitor_lob,
      :local_lob
    ])
  end
end
