defmodule BaseballDigitalManager.Repo.Migrations.CreateLibraries do
  use Ecto.Migration

  def change do
    create table(:libraries) do
      add :name, :string
      add :starting_year, :integer
      add :default_path, :string

      timestamps()
    end
  end
end
