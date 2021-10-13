defmodule TspSolver.Solver.Greedy do
  @moduledoc """
  A module for executing a greedy pathfinding algorithm for solving a travelling salesman problem.
  """

  alias TspSolver.Point

  @doc """
  Executes a greedy pathfinding algorithm for solving a travelling salesman problem.

  Returns a list of points in a calculated order.

  ## Parameters

    - point_from: A point being a start of the path.
    - list_of_points: List of points through which the path must be led.

  """
  @spec solve_greedy(%Point{} | list(%Point{}), list(%Point{})) :: list(%Point{})

  def solve_greedy(point_from = %{}, list_of_points) do
    solve_greedy([point_from], list_of_points)
  end

  def solve_greedy(list_of_points_from, []) do
    list_of_points_from
    |> Enum.reverse()
  end

  def solve_greedy([point_from | _] = list_of_points_from, list_of_points_to) do
    closest_point = find_closest_point(point_from, list_of_points_to)

    remaining_points =
      Enum.filter(list_of_points_to, fn point ->
        point != closest_point
      end)

    solve_greedy([closest_point | list_of_points_from], remaining_points)
  end

  @doc """
  Finds and returns the closes point to a given point for a given list of points.

  Returns `%Point{}` closest to `point_from`.

  ## Parameters

    - point_from: A point for which we search a closes point from `list_of_points`
    - list_of_points: A list of points from which we find a point closest to `point_from`.

  """
  @spec find_closest_point(%Point{}, list(%Point{})) :: %Point{}
  defp find_closest_point(point_from, list_of_points) do
    %{index: closest_point_index} =
      get_distance_for_list_of_points(point_from, list_of_points)
      |> find_smallest_distance()

    Enum.find(list_of_points, fn %{index: point_index} ->
      point_index == closest_point_index
    end)
  end

  @doc """
  Calculates a distance from a given point to given set of points and returns these distances.

  Returns `list(%{index: number(), distance_to: number()})` containing an index of a point and a distance to it.

  ## Parameters

    - point_from: A point from which we calculate distance to every point from `list_of_points`.
    - list_of_points: A list of points to which we calculate distance from `point_from`.
  """
  @spec get_distance_for_list_of_points(%Point{}, list(%Point{})) :: list(%Point{})
  defp get_distance_for_list_of_points(%{coords: point_from_coords} = _point_from, list_of_points) do
    Enum.map(list_of_points, fn point ->
      %{index: point_index, coords: point_to_coords} = point
      %{index: point_index, distance_to: distance_between(point_from_coords, point_to_coords)}
    end)
  end

  @doc """
  Calculates a distance between two sets of x/y coordinates using Pythagorean theorem.

  Returns `number()` respresenting a distance between two given points.

  ## Parameters

    - point_1: A list containing two numbers holding "x" and "y" coordinates.
    - point_2: A list containing two numbers holding "x" and "y" coordinates.

  ## Examples

    distance_between([0, 0], [3, 3]) :: 4.24264
  """
  @spec distance_between(list(number()), list(number())) :: number()
  defp distance_between([x1, y1] = _point_1, [x2, y2] = _point_2) do
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
