defmodule TspSolver.Solver.Helper do
  def prepare_data_to_process(
        {_starting_point = %{"index" => starting_point_index, "coords" => starting_point_coords},
         list_of_points}
      ) do
    new_starting_point = %{
      "index" => starting_point_index,
      "coords" => List.to_tuple(starting_point_coords)
    }

    new_list_of_points =
      Enum.map(list_of_points, fn %{"index" => index, "coords" => coords} ->
        %{index: index, coords: List.to_tuple(coords)}
      end)

    {:ok, {new_starting_point, new_list_of_points}}
  end

  def prepare_data_to_send(
        {_starting_point = %{"index" => starting_point_index, "coords" => starting_point_coords},
         list_of_points}
      ) do
    new_starting_point = %{
      "index" => starting_point_index,
      "coords" => Tuple.to_list(starting_point_coords)
    }

    new_list_of_points =
      Enum.map(list_of_points, fn %{"index" => index, "coords" => coords} ->
        %{index: index, coords: Tuple.to_list(coords)}
      end)

    {:ok, {new_starting_point, new_list_of_points}}
  end
end
