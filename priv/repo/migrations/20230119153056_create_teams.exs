defmodule BaseballDigitalManager.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :nick_name, :string
      add :short_name, :string
      add :league_id, references(:leagues, on_delete: :nothing)
      add :division_id, references(:divisions, on_delete: :nothing)
      add :current_season_wins, :integer
      add :current_season_losses, :integer

      timestamps()
    end

    create index(:teams, [:league_id])
    create index(:teams, [:division_id])
  end
end
