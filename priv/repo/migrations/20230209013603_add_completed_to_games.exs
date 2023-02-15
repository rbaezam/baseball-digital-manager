defmodule BaseballDigitalManager.Repo.Migrations.AddCompletedToGames do
  use Ecto.Migration

  def change do
    alter table("games") do
      add :is_completed, :boolean, default: false
    end
  end
end
