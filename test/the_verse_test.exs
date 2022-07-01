defmodule TheVerseTest do
  use ExUnit.Case
  doctest TheVerse

  test "greets the world" do
    assert TheVerse.hello() == :world
  end
end
