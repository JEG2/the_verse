defmodule TheVerse.Sector do
  @moduledoc ~S"""
  Types and functions for managing a location in the game world and its
  contents.
  """

  alias TheVerse.Sector.Connections

  @typedoc ~S"""
  A data structure containing details about what's present in a single location
  of the game world map.
  """
  @type t :: %__MODULE__{
          connections: Connections.t(),
          name: String.t(),
          xy: XY.t()
        }
  @enforce_keys ~w[name xy]a
  defstruct connections: Connections.new(),
            name: nil,
            xy: nil

  @doc ~S"""
  Constructs a new `Sector` from the provided fields.
  """
  @spec new(Enum.t()) :: t()
  def new(fields \\ []) do
    struct!(
      __MODULE__,
      Enum.map(fields, fn
        {:connections, connections} ->
          {:connections, Connections.new(connections)}

        pair ->
          pair
      end)
    )
  end

  @doc ~S"""
  Return the available `Connections` from `sector`.
  """
  @spec available_connections(t()) :: Connections.available()
  def available_connections(sector) do
    Connections.available(sector.connections)
  end

  @doc ~S"""
  Places `to` in `from`'s `Connections` at `dir`.
  """
  @spec connect(t(), TheVerse.Dir.t(), t()) :: t()
  def connect(from, dir, to) do
    connections = Connections.add(from.connections, dir, to.name)
    %__MODULE__{from | connections: connections}
  end
end
