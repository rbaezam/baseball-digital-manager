defmodule BaseballDigitalManager.Libraries.Library do
  use Ecto.Schema
  import Ecto.Changeset

  schema "libraries" do
    field :default_path, :string
    field :name, :string
    field :starting_year, :integer
    field :current_date, :utc_datetime

    has_many :leagues, BaseballDigitalManager.Leagues.League

    timestamps()
  end

  @doc false
  def changeset(library, attrs) do
    library
    |> cast(attrs, [:name, :starting_year, :default_path])
    |> validate_required([:name, :starting_year, :default_path])
  end
end
