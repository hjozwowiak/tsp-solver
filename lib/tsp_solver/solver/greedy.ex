defmodule TspSolver.Solver.Greedy do
  @spec solve_greedy(map() | list(), list()) :: list()

  def solve_greedy(point_from = %{}, list_of_points) do
    solve_greedy([point_from], list_of_points)
  end

  def solve_greedy(list_of_points_from, []) do
    list_of_points_from
  end

  def solve_greedy([point_from | _] = list_of_points_from, list_of_points_to) do
    closest_point = find_closest_point(point_from, list_of_points_to)

    remaining_points =
      Enum.filter(list_of_points_to, fn point ->
        point != closest_point
      end)

    solve_greedy([closest_point | list_of_points_from], remaining_points)
  end

  @spec find_closest_point(
          point_from :: %{index: number() | nil, coords: {binary(), binary()}},
          list()
        ) :: %{index: number() | nil, coords: {binary(), binary()}}
  defp find_closest_point(point_from, list_of_points) do
    %{index: closest_point_index} =
      get_distance_for_list_of_points(point_from, list_of_points)
      |> find_smallest_distance()

    Enum.find(list_of_points, fn %{index: point_index} ->
      point_index == closest_point_index
    end)
  end

  @spec get_distance_for_list_of_points(
          %{index: number() | nil, coords: point_from_coords :: {binary(), binary()}},
          list()
        ) :: list()
  defp get_distance_for_list_of_points(%{coords: point_from_coords}, list_of_points) do
    Enum.map(list_of_points, fn point ->
      %{index: point_index, coords: point_to_coords} = point
      %{index: point_index, distance_to: distance_between(point_from_coords, point_to_coords)}
    end)
  end

  @spec distance_between({x1 :: number(), y1 :: number()}, {x2 :: number(), y2 :: number()}) ::
          number()
  defp distance_between({x1, y1}, {x2, y2}) do
    (:math.pow(abs(x1 - x2), 2) + :math.pow(abs(y1 - y2), 2))
    |> :math.sqrt()
  end

  @spec find_smallest_distance(list_of_distances :: list()) :: %{index: number()}
  defp find_smallest_distance(list_of_distances) do
    Enum.min_by(list_of_distances, fn %{distance_to: distance} ->
      distance
    end)
  end
end
