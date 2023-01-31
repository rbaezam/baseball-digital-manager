defmodule BaseballDigitalManager.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BaseballDigitalManagerWeb.Telemetry,
      # Start the Ecto repository
      BaseballDigitalManager.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: BaseballDigitalManager.PubSub},
      # Start Finch
      {Finch, name: BaseballDigitalManager.Finch},
      # Start the Endpoint (http/https)
      BaseballDigitalManagerWeb.Endpoint
      # Start a worker by calling: BaseballDigitalManager.Worker.start_link(arg)
      # {BaseballDigitalManager.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BaseballDigitalManager.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BaseballDigitalManagerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
