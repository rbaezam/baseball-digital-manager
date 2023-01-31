defmodule BaseballDigitalManager.Repo.Migrations.CreateBattingStats do
  use Ecto.Migration

  def change do
    create table(:batting_stats) do
      add :games, :integer
      add :plate_appearances, :integer
      add :at_bats, :integer
      add :runs, :integer
      add :hits, :integer
      add :doubles, :integer
      add :triples, :integer
      add :homeruns, :integer
      add :rbis, :integer
      add :stolen_bases, :integer
      add :caught_stealing, :integer
      add :base_on_balls, :integer
      add :strikeouts, :integer
      add :grounded_into_doubleplays, :integer
      add :hit_by_pitch, :integer
      add :sacrifice_hits, :integer
      add :sacrifice_flies, :integer
      add :intentional_base_on_balls, :integer
      add :player_id, references(:players, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)
      add :season_id, references(:seasons, on_delete: :nothing)

      timestamps()
    end

    create index(:batting_stats, [:player_id])
    create index(:batting_stats, [:team_id])
    create index(:batting_stats, [:season_id])
  end
end
