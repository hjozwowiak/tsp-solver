defmodule TspSolver.Solver.Helper do
  # def prepare_data_to_process(input) do
  #   IO.inspect(input)
  # end

  @spec prepare_data_to_process(list()) :: {:ok, map()}
  def prepare_data_to_process([
        %{"index" => starting_point_index, "coords" => starting_point_coords}
        | list_of_points
      ]) do
    new_starting_point = %{
      index: starting_point_index,
      coords: List.to_tuple(starting_point_coords)
    }

    new_list_of_points =
      Enum.map(list_of_points, fn %{"index" => index, "coords" => coords} ->
        %{index: index, coords: List.to_tuple(coords)}
      end)

    {:ok, %{starting_point: new_starting_point, list_of_points: new_list_of_points}}
  end

  @spec prepare_data_to_send(list()) :: {:ok, list()}

  def prepare_data_to_send(list_of_points) do
    new_list_of_points =
      Enum.map(list_of_points, fn %{index: index, coords: coords} ->
        %{index: index, coords: Tuple.to_list(coords)}
      end)
      |> Enum.reverse()

    {:ok, new_list_of_points}
  end
end
