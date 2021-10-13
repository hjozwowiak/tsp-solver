defmodule TspSolver.Solver.Helper do
  alias TspSolver.Point

  @spec prepare_data_to_process(list()) ::
          {:ok, %{starting_point: %Point{}, list_of_points: list(%Point{})}}
  def prepare_data_to_process([
        %{"index" => starting_point_index, "coords" => starting_point_coords}
        | list_of_points
      ]) do
    new_starting_point = %{
      index: starting_point_index,
      coords: List.to_tuple(starting_point_coords)
    }

    new_starting_point =
      struct(Point, %{index: starting_point_index, coords: starting_point_coords})

    new_list_of_points =
      Enum.map(list_of_points, fn %{"index" => index, "coords" => coords} ->
        struct(Point, %{index: index, coords: coords})
      end)

    {:ok, %{starting_point: new_starting_point, list_of_points: new_list_of_points}}
  end

  @spec prepare_data_to_send(list()) :: {:ok, list()}
  def prepare_data_to_send(list_of_points) do
    new_list_of_points =
      Enum.map(list_of_points, fn point ->
        Map.from_struct(point)
      end)

    {:ok, new_list_of_points}
  end
end
