defmodule BaseballDigitalManager.Repo.Migrations.AddHomerunsToPitchingStats do
  use Ecto.Migration

  def change do
    alter table("game_pitching_stats") do
      add :homeruns_allowed, :integer
    end
  end
end
