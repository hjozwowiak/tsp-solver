defmodule TspSolver.GenerateProblemInstance do
  alias TspSolver.Point
  alias TspSolver.ProblemInstance
  alias TspSolver.Generator.GenerateProblemInstance.Command, as: GenerateProblemInstanceCommand

  @spec call(GenerateProblemInstanceCommand.t()) :: {:ok, ProblemInstance.t()}
  def call(command) do
    all_points =
      generate_all_points(
        {command.min_x, command.min_x, command.max_x},
        {command.min_y, command.min_y, command.max_y}
      )

    chosen_points =
      all_points
      |> Enum.take_random(command.number_of_points)
      |> Enum.sort_by(&{Enum.at(&1.coords, 0), Enum.at(&1.coords, 1)})
      |> map_indexes()

    {:ok, struct(ProblemInstance, %{points: chosen_points})}
  end

  @spec generate_all_points(tuple(), tuple()) :: list(Point.t())
  defp generate_all_points({x, min_x, max_x}, {y, min_y, max_y}) do
    new_point = struct(Point, %{coords: [x, y]})

    cond do
      x == max_x and y == max_y ->
        [new_point]

      y == max_y ->
        [new_point | generate_all_points({x + 1, min_x, max_x}, {min_y, min_y, max_y})]

      true ->
        [new_point | generate_all_points({x, min_x, max_x}, {y + 1, min_y, max_y})]
    end
  end

  defp map_indexes(list_of_points) do
    Enum.reduce(list_of_points, [], fn point, list_of_points ->
      index =
        list_of_points
        |> case do
          [_ | _] -> list_of_points |> List.first() |> Map.get(:index) |> Kernel.+(1)
          [] -> 0
        end

      point_with_index = struct(Point, %{Map.from_struct(point) | index: index})

      [point_with_index | list_of_points]
    end)
    |> Enum.reverse()
  end
end
