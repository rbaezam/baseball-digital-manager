defmodule BaseballDigitalManager.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :last_name, :string
      add :first_name, :string
      add :bats, :string
      add :throws, :string
      add :height, :integer
      add :weight, :integer
      add :date_of_birth, :date
      add :place_of_birth, :string
      add :debut_date, :date
      add :team_id, references(:teams, on_delete: :nothing)
      add :main_position, :string
      add :secondary_position, :string, null: true
      add :pitcher_type, :string

      timestamps()
    end

    create index(:players, [:team_id])
  end
end
