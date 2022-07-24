defmodule TheVerse.GameCase do
  use ExUnit.CaseTemplate

  defmodule Helpers do
    alias TheVerse.{Config, XY}

    @spec build_config(Config.t()) :: Config.t()
    def build_config(changes \\ []) do
      Enum.reduce(changes, Config.default(), fn {setting, value}, config ->
        {:ok, config} = Config.update(config, setting, value)
        config
      end)
    end

    @spec build_sector_fields(keyword()) :: keyword()
    def build_sector_fields(fields \\ []) do
      Keyword.merge([name: "42", xy: xy(0, 0)], fields)
    end

    @spec xy(integer(), integer()) :: XY.t()
    def xy(x, y), do: XY.new(x, y)
  end

  using do
    quote do
      import Helpers
    end
  end
end
