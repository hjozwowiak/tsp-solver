defmodule TspSolverWeb.SolverChannel do
  use Phoenix.Channel

  alias TspSolver.Generator

  def join("solver:" <> _id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("generate_instance", %{"body" => params}, socket) do
    {:ok, problem_instance} = Generator.generate_problem_instance(params)

    broadcast!(socket, "problem_instance", %{body: problem_instance})

    {:noreply, socket}
  end

  def handle_in("solve", %{"body" => instance}, socket) do
    {:ok, solution} = TspSolver.Solver.solve_traveling_salesman_problem(:greedy, instance)

    broadcast!(socket, "solution", %{body: solution})

    {:noreply, socket}
  end
end
