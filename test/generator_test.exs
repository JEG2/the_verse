defmodule GeneratorTest do
  use TheVerse.GameCase

  alias TheVerse.{Sector, Universe}
  alias TheVerse.Universe.Generator

  test "generates a universe based on the passed config" do
    config = build_config()
    assert is_struct(Generator.generate(config), Universe)
  end

  test "produces a map centered on a densely connected cluster of sectors" do
    config = build_config(sectors: 7, x_limit: 5, y_limit: 5)
    universe = Generator.generate(config)

    assert %Sector{} = one = Universe.locate(universe, xy(0, 0))

    Enum.each(~w[2 3 4 5 6 7], fn neighbor_name ->
      assert %Sector{} = neighbor = Universe.locate(universe, neighbor_name)
      assert neighbor.name in Sector.available_connections(one)
      assert one.name in Sector.available_connections(neighbor)
    end)
  end
end
