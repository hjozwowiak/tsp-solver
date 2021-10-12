defmodule TspSolver.GenerateProblemInstance do
  alias TspSolver.Solver.Point
  alias TspSolver.ProblemInstance
  alias TspSolver.Generator.GenerateProblemInstance.Command, as: GenerateProblemInstanceCommand

  @spec call(GenerateProblemInstanceCommand.t()) :: ProblemInstance.t()
  def call(command) do
    all_points = generate_all_points(0, {5, 5, 7}, {8, 8, 10})

    chosen_points =
      all_points
      |> Enum.take_random(command.number_of_points)
      |> Enum.sort(&(&1.index < &2.index))

    struct(ProblemInstance, %{points: chosen_points})
  end

  @spec generate_all_points(integer(), tuple(), tuple()) :: list(Point.t())
  defp generate_all_points(index, {x, min_x, max_x}, {y, min_y, max_y}) do
    new_point = struct(Point, %{coords: [x, y], index: index})

    cond do
      x == max_x and y == max_y ->
        [new_point]

      y == max_y ->
        [new_point | generate_all_points(index + 1, {x + 1, min_x, max_x}, {min_y, min_y, max_y})]

      true ->
        [new_point | generate_all_points(index + 1, {x, min_x, max_x}, {y + 1, min_y, max_y})]
    end
  end
end
