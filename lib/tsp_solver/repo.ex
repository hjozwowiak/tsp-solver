defmodule TspSolver.Repo do
  use Ecto.Repo,
    otp_app: :tsp_solver,
    adapter: Ecto.Adapters.Postgres
end
