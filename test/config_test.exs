defmodule ConfigTest do
  use TheVerse.GameCase

  alias TheVerse.Config

  test "provides a ready-to-use config" do
    assert is_struct(Config.default(), Config)
  end

  test "allows updating of configured settings" do
    config = build_config()
    refute config.sectors == 50
    assert {:ok, %Config{} = config} = Config.update(config, :sectors, 50)
    assert config.sectors == 50
  end

  test "pseudo limits set both ends at once" do
    config = build_config()

    refute config.min_x == -1_000
    refute config.max_x == 1_000
    assert {:ok, %Config{} = config} = Config.update(config, :x_limit, 1_000)
    assert config.min_x == -1_000
    assert config.max_x == 1_000

    refute config.min_y == -2_000
    refute config.max_y == 2_000
    assert {:ok, %Config{} = config} = Config.update(config, :y_limit, 2_000)
    assert config.min_y == -2_000
    assert config.max_y == 2_000
  end

  test "ensures sectors is an integer" do
    config = build_config()
    assert is_integer(config.sectors)
    assert {:error, message} = Config.update(config, :sectors, "oops")
    assert String.contains?(message, "an integer")
  end

  test "ensures that there are at least seven sectors" do
    config = build_config()
    assert {:error, message} = Config.update(config, :sectors, 6)
    assert String.contains?(message, "at least seven")
  end

  test "ensures coordinate limits are integers" do
    config = build_config()

    Enum.each(~w[min_x max_x min_y max_y]a, fn limit ->
      assert config |> Map.fetch!(limit) |> is_integer
      assert {:error, message} = Config.update(config, limit, "oops")
      assert String.contains?(message, "an integer")
    end)
  end

  test "ensures the requested sectors fit in the coordinates" do
    config =
      build_config(
        sectors: 100,
        min_x: 1,
        max_x: 10,
        min_y: 1,
        max_y: 10
      )

    assert {:error, message} = Config.update(config, :sectors, 101)
    assert String.contains?(message, "exceeds coordinate space")
  end

  test "ensures minimums are at or below maximums" do
    config = build_config()

    %{min_x: :max_x, min_y: :max_y}
    |> Enum.each(fn {min, max} ->
      value = Map.fetch!(config, max) + 1
      assert {:error, message} = Config.update(config, min, value)
      assert String.contains?(message, "at or below")
    end)
  end

  test "ensures maximums are above minimums" do
    config = build_config()

    %{max_x: :min_x, max_y: :min_y}
    |> Enum.each(fn {max, min} ->
      value = Map.fetch!(config, min)
      assert {:error, message} = Config.update(config, max, value)
      assert String.contains?(message, "above")
    end)
  end

  test "returns an error message related to the passed setting" do
    config = build_config(sectors: 121, x_limit: 5, y_limit: 5)

    %{min_x: -4, max_x: 4, min_y: -4, max_y: 4, x_limit: 4, y_limit: 4}
    |> Enum.each(fn {limit, value} ->
      assert {:error, message} = Config.update(config, limit, value)
      assert String.contains?(message, "won't contain sectors")
    end)
  end

  test "ensures pseudo limits are positive integers" do
    config = build_config()

    ~w[x_limit y_limit]a
    |> Enum.each(fn limit ->
      ["oops", -1]
      |> Enum.each(fn value ->
        assert {:error, message} = Config.update(config, limit, value)
        assert String.contains?(message, "a positive integer")
      end)
    end)
  end
end
