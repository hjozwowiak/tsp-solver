defmodule TspSolver.Solver do
  alias TspSolver.Solver.Helper
  alias TspSolver.Solver.Greedy

  @spec solve_traveling_salesman_problem(atom(), list()) :: {:ok, list()}
  def solve_traveling_salesman_problem(:greedy, list_of_all_points) do
    {:ok, %{starting_point: starting_point, list_of_points: list_of_points}} =
      Helper.prepare_data_to_process(list_of_all_points)

    Greedy.solve_greedy(starting_point, list_of_points)
    |> Helper.prepare_data_to_send()
  end
end
