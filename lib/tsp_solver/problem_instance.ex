defmodule TspSolver.ProblemInstance do
  import Ecto.Changeset

  alias TspSolver.Solver.Point

  @type t :: %__MODULE__{
          points: list(Point.t())
        }

  @fields [:points]

  defstruct @fields

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:coords, min: 1)
  end
end
