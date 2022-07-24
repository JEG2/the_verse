defmodule UniverseTest do
  use TheVerse.GameCase

  alias TheVerse.{Sector, Universe}

  test "begins as an empty data structure" do
    universe = Universe.empty()
    assert universe.size == 0
  end

  test "can be expanded by one sector" do
    universe = Universe.empty()
    sector_fields = build_sector_fields()

    assert universe.size == 0
    universe = Universe.expand(universe, sector_fields)
    assert universe.size == 1
  end

  test "expand raises when given invalid sector fields" do
    universe = Universe.empty()
    sector_fields = build_sector_fields()

    # can't duplicate names or coordinates
    universe = Universe.expand(universe, sector_fields)

    assert_raise RuntimeError, fn ->
      Universe.expand(universe, sector_fields)
    end

    # must create a valid struct
    assert_raise ArgumentError, fn ->
      Universe.expand(universe, [])
    end
  end

  test "a sector can be found by name or coordinates" do
    universe = Universe.empty()
    sector_fields = build_sector_fields()

    universe = Universe.expand(universe, sector_fields)
    assert %Sector{} = Universe.locate(universe, sector_fields[:name])
    assert %Sector{} = Universe.locate(universe, sector_fields[:xy])
  end

  test "nil is returned when a matching sector can't be found" do
    universe = Universe.empty()
    assert is_nil(Universe.locate(universe, "not found"))
  end
end
