defmodule BaseballDigitalManager.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :season, :integer
      add :date, :date
      add :visitor_runs, :integer
      add :local_runs, :integer
      add :visitor_hits, :integer
      add :local_hits, :integer
      add :visitor_errors, :integer
      add :local_errors, :integer
      add :visitor_lob, :integer
      add :local_lob, :integer
      add :library_id, references(:libraries, on_delete: :nothing)
      add :visitor_team_id, references(:teams, on_delete: :nothing)
      add :local_team_id, references(:teams, on_delete: :nothing)

      timestamps()
    end

    create index(:games, [:library_id])
    create index(:games, [:visitor_team_id])
    create index(:games, [:local_team_id])
  end
end
