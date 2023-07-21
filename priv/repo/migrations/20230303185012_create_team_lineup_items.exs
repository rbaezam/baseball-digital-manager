defmodule BaseballDigitalManager.Repo.Migrations.CreateTeamLineupItems do
  use Ecto.Migration

  def change do
    create table(:team_lineup_items) do
      add :order, :integer
      add :position, :string
      add :full_name, :string
      add :bats, :string
      add :lineup_id, references(:team_lineups, on_delete: :nothing)
      add :player_id, references(:players, on_delete: :nothing)

      timestamps()
    end

    create index(:team_lineup_items, [:lineup_id])
    create index(:team_lineup_items, [:player_id])
  end
end
