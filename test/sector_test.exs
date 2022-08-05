defmodule SectorTest do
  use TheVerse.GameCase

  alias TheVerse.Sector
  alias TheVerse.Sector.Connections

  test "constructs sectors from fields" do
    sector = Sector.new(name: "Test Sector", xy: xy(1, 2))
    assert is_struct(sector, Sector)
    assert sector.name == "Test Sector"
    assert sector.xy == xy(1, 2)
  end

  test "construction always includes all connection directions" do
    sector = Sector.new(name: "1", xy: xy(3, 4), connections: %{ne: "2"})

    assert %Connections{
             ne: "2",
             e: nil,
             se: nil,
             sw: nil,
             w: nil,
             nw: nil
           } = sector.connections
  end

  test "construction fails when missing required fields" do
    assert_raise ArgumentError, fn ->
      Sector.new(name: "Test Sector")
    end

    assert_raise ArgumentError, fn ->
      Sector.new(xy: xy(1, 2))
    end
  end

  test "construction fails when given invalid fields" do
    assert_raise KeyError, fn ->
      Sector.new(name: "Test Sector", xy: xy(1, 2), invalid: "field")
    end
  end

  test "connections can be made and checked" do
    sector = Sector.new(name: "1", xy: xy(0, 0))
    assert is_nil(sector.connections.w)
    assert Sector.available_connections(sector) == []

    sector = Sector.connect(sector, :w, Sector.new(name: "2", xy: xy(1, 0)))
    assert sector.connections.w == "2"
    assert Sector.available_connections(sector) == ["2"]
  end

  test "reconnecting sectors is an error" do
    one = Sector.new(name: "1", xy: xy(0, 0))
    two = Sector.new(name: "2", xy: xy(1, 0))

    one = Sector.connect(one, :w, two)

    assert_raise ArgumentError, fn ->
      Sector.connect(one, :w, two)
    end
  end
end
