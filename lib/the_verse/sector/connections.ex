defmodule TheVerse.Sector.Connections do
  @moduledoc ~S"""
  Types and functions for managing a collection of `Sector` connections.
  """

  @typedoc ~S"""
  A listing of all `Connections` a `Sector` can have, by `Dir`.
  """
  @type t :: %__MODULE__{
          ne: String.t() | nil,
          e: String.t() | nil,
          se: String.t() | nil,
          sw: String.t() | nil,
          w: String.t() | nil,
          nw: String.t() | nil
        }
  defstruct ne: nil, e: nil, se: nil, sw: nil, w: nil, nw: nil

  @typedoc ~S"""
  A listing of available connection names without `Dir`s.
  """
  @type available :: [String.t()]

  @doc ~S"""
  Constructs a new collections of `Connections` from the provided fields.
  """
  @spec new(Enum.t()) :: t()
  def new(fields \\ []), do: struct!(__MODULE__, fields)

  @doc ~S"""
  `Connections` always lists all possible connections. Often, some of those
  `Connections` will be `nil` simply because the parent `Sector` doesn't have
  the maximum allowable `Connections`.  Also, `Connections` are always listed by
  `Dir`, which isn't always relevant.

  This function returns a list of `Sector` names available from the passed
  `connections`.
  """
  @spec available(t()) :: available()
  def available(connections) do
    connections
    |> Map.from_struct()
    |> Map.values()
    |> Enum.reject(&is_nil/1)
  end

  @doc ~S"""
  Adds the passed `Sector` `name` to `connections` at `dir`.  Raises an error if
  a connection already exists at `dir`.
  """
  @spec add(t(), TheVerse.Dir.t(), String.t()) :: t()
  def add(connections, dir, name) do
    if is_binary(Map.fetch!(connections, dir)) do
      raise ArgumentError, "Existing connection"
    end

    struct!(connections, [{dir, name}])
  end
end
