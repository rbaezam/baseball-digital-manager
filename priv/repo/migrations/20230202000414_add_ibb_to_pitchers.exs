defmodule BaseballDigitalManager.Repo.Migrations.AddIBBToPitchers do
  use Ecto.Migration

  def change do
    alter table("game_pitching_stats") do
      add :intentional_base_on_balls, :integer
    end
  end
end
