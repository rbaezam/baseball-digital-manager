defmodule BaseballDigitalManager.Repo do
  use Ecto.Repo,
    otp_app: :baseball_digital_manager,
    adapter: Ecto.Adapters.Postgres
end
