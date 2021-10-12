defmodule TspSolver.Generator.GenerateProblemInstance.Command do
  import Ecto.Changeset

  alias TspSolver.Solver.Point

  @type t :: %__MODULE__{
          max_x: integer(),
          max_y: integer(),
          min_x: integer(),
          min_y: integer(),
          number_of_points: integer()
        }

  @fields [:max_x, :max_y, :min_x, :min_y, :number_of_points]

  defstruct @fields

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:number_of_points,
      max: (:max_x - :min_x) * (:max_y - :min_y),
      message:
        "Number of points cannot exceed the possible maximum number of points on a map of a given size."
    )
  end
end
