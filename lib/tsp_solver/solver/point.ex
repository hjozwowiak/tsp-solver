defmodule TspSolver.Solver.Point do
  import Ecto.Changeset

  @type t :: %__MODULE__{
          coords: list(integer()),
          index: integer()
        }

  @fields [:coords, :index]

  defstruct @fields

  def changeset(params) do
    %__MODULE__{}
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_length(:coords, 2)
  end
end
