defmodule TspSolver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TspSolver.Repo,
      # Start the Telemetry supervisor
      TspSolverWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TspSolver.PubSub},
      # Start the Endpoint (http/https)
      TspSolverWeb.Endpoint
      # Start a worker by calling: TspSolver.Worker.start_link(arg)
      # {TspSolver.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TspSolver.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TspSolverWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
