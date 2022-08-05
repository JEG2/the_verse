defmodule TheVerse.Universe do
  @moduledoc ~S"""
  Types and functions for managing the game world and its detectable-by-players
  contents.
  """

  alias TheVerse.Sector

  @typedoc ~S"""
  A data structure for managing the map of the game world and its contents.
  """
  @type t :: %__MODULE__{
          sectors: %{String.t() => Sector.t()},
          size: pos_integer(),
          xy_index: %{XY.t() => String.t()}
        }
  defstruct sectors: Map.new(),
            size: 0,
            xy_index: Map.new()

  @spec empty() :: t()
  def empty, do: %__MODULE__{}

  @doc ~S"""
  Constructs a `Sector` from `sector_fields` and adds it to the known
  `universe`.  Will raise if `sector_fields` represent an invalid or duplicate
  `Sector`.
  """
  @spec expand(t(), keyword()) :: t()
  def expand(universe, sector_fields) do
    sector = Sector.new(sector_fields)

    if Map.has_key?(universe.sectors, sector.name) or
         Map.has_key?(universe.xy_index, sector.xy) do
      raise "Duplicate sector"
    end

    sectors = Map.put(universe.sectors, sector.name, sector)
    xy_index = Map.put(universe.xy_index, sector.xy, sector.name)

    %__MODULE__{
      universe
      | sectors: sectors,
        size: map_size(sectors),
        xy_index: xy_index
    }
  end

  def connect(universe, from_name_or_xy, dir, to_name_or_xy) do
    from = locate(universe, from_name_or_xy)
    to = locate(universe, to_name_or_xy)

    from = Sector.connect(from, dir, to)
    sectors = Map.put(universe.sectors, from.name, from)
    %__MODULE__{universe | sectors: sectors}
  end

  @doc ~S"""
  Looks up a `Sector` in `universe` by `sector_name` or `xy`.  Returns `nil`
  if no matching `Sector` exists.
  """
  @spec locate(t(), String.t() | XY.t()) :: Sector.t() | nil
  def locate(universe, sector_name) when is_binary(sector_name) do
    Map.get(universe.sectors, sector_name)
  end

  def locate(universe, xy) when is_tuple(xy) do
    with sector_name when is_binary(sector_name) <-
           Map.get(universe.xy_index, xy) do
      locate(universe, sector_name)
    end
  end
end
