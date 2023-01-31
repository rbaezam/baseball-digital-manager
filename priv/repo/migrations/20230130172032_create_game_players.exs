defmodule BaseballDigitalManager.Repo.Migrations.CreateGamePlayers do
  use Ecto.Migration

  def change do
    create table(:game_players) do
      add :position, :string
      add :is_local_team, :boolean, default: false
      add :team_id, references(:teams, on_delete: :nothing)
      add :game_id, references(:games, on_delete: :nothing)
      add :player_id, references(:players, on_delete: :nothing)

      timestamps()
    end

    create index(:game_players, [:team_id])
    create index(:game_players, [:game_id])
    create index(:game_players, [:player_id])
  end
end
