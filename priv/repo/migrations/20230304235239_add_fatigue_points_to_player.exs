defmodule BaseballDigitalManager.Repo.Migrations.AddFatiguePointsToPlayer do
  use Ecto.Migration

  def change do
    alter table("players") do
      add :fatigue_points, :integer, default: 0
    end
  end
end
