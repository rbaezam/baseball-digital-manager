defmodule BaseballDigitalManager.Repo.Migrations.AddSeasonIdToTeams do
  use Ecto.Migration

  def change do
    alter table("teams") do
      add :season_id, :integer
    end

    create(index(:teams, [:season_id]))
  end
end
