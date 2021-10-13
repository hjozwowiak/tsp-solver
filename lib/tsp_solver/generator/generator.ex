defmodule TspSolver.Generator do
  alias TspSolver.Generator.GenerateProblemInstance.Command, as: GenerateProblemInstanceCommand
  alias TspSolver.GenerateProblemInstance

  def generate_problem_instance(params) do
    command =
      struct(GenerateProblemInstanceCommand, %{
        max_x: params["max_x"],
        max_y: params["max_y"],
        min_x: params["min_x"],
        min_y: params["min_y"],
        number_of_points: params["number_of_points"]
      })

    {:ok, problem_instance} = GenerateProblemInstance.call(command)

    {:ok, Enum.map(problem_instance.points, &Map.from_struct/1)}
  end
end
