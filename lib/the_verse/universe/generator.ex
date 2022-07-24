defmodule TheVerse.Universe.Generator do
  @moduledoc ~S"""
  The functions of this module turn a `Config` into a playable world.  The
  generation process is largely random but it adheres to certain expectations to
  create a predictable gameplay experience.
  """

  alias TheVerse.{Config, Universe, XY}

  defstruct center: nil,
            config: nil,
            universe: Universe.empty()

  @doc ~S"""
  The external interface of this module.  Callers prepare and pass a `config`
  with their desired settings.  This function builds a random `Universe`
  conforming to those settings.
  """
  @spec generate(Config.t()) :: Universe.t()
  def generate(config) do
    config
    |> from_config()
    |> generate_core()
    |> to_universe()
  end

  defp from_config(config) do
    center_x = trunc((config.max_x - config.min_x + 1) / 2) + config.min_x
    center_y = trunc((config.max_y - config.min_y + 1) / 2) + config.min_y

    %__MODULE__{center: XY.new(center_x, center_y), config: config}
  end

  defp generate_core(big_bang) do
    universe =
      big_bang.universe
      |> Universe.expand(name: "1", xy: big_bang.center)

    universe =
      Enum.reduce(
        %{ne: "2", e: "3", se: "4", sw: "5", w: "6", nw: "7"},
        universe,
        fn {direction, name}, universe ->
          opposite_direction =
            case direction do
              :ne -> :sw
              :e -> :w
              :se -> :nw
              :sw -> :ne
              :w -> :e
              :nw -> :se
            end

          universe
          |> Universe.expand(
            name: name,
            xy: apply(XY, direction, [big_bang.center])
          )
          |> Universe.connect("1", direction, name)
          |> Universe.connect(name, opposite_direction, "1")
        end
      )

    %__MODULE__{big_bang | universe: universe}
  end

  defp to_universe(big_bang), do: big_bang.universe
end
