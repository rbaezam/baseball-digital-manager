defmodule BaseballDigitalManager.Repo.Migrations.AddCurrentDateToLibrary do
  use Ecto.Migration

  def change do
    alter table("libraries") do
      add :current_date, :utc_datetime
    end
  end
end
