defmodule TheVerse.Sector do
  @moduledoc ~S"""
  Types and functions for managing a location in the game world and its
  contents.
  """

  @typedoc ~S"""
  A data structure containing details about what's present in a single location
  of the game world map.
  """
  @type t :: %__MODULE__{
          name: String.t(),
          xy: XY.t()
        }
  @enforce_keys ~w[name xy]a
  defstruct name: nil,
            neighbors: %{ne: nil, e: nil, se: nil, sw: nil, w: nil, nw: nil},
            xy: nil

  def new(fields \\ []) do
    struct!(__MODULE__, fields)
  end

  def neighbors(sector) do
    sector.neighbors
    |> Map.values()
    |> Enum.reject(&is_nil/1)
  end
end
