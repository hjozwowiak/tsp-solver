defmodule TspSolverWeb.SolverChannel do
  use Phoenix.Channel

  def join("solver:" <> _id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("solve", %{"body" => instance}, socket) do
    {:ok, solution} = TspSolver.Solver.solve_traveling_salesman_problem(:greedy, instance)

    broadcast!(socket, "solution", %{body: solution})

    {:noreply, socket}
  end
end
