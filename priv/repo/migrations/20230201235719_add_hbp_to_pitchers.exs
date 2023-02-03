defmodule BaseballDigitalManager.Repo.Migrations.AddHBPToPitchers do
  use Ecto.Migration

  def change do
    alter table("game_pitching_stats") do
      add :hits_by_pitch, :integer
    end
‰  end
end
