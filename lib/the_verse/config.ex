defmodule TheVerse.Config do
  @moduledoc ~S"""
  Types and functions for managing the configurable settings of a game.  Effort
  is taken to ensure that any configuration is always valid.
  """

  @typedoc ~S"""
  A data structure for storing the game's configuration.  Keys represent the
  possible settings for a game while values represent the current choices.

  It's fine to read these values directly, but all changes should go through
  `update/3` to ensure they are valid.
  """
  @type t :: %__MODULE__{
          sectors: pos_integer(),
          min_x: integer(),
          min_y: integer(),
          max_x: integer(),
          max_y: integer()
        }
  defstruct sectors: 1_000,
            min_x: -100,
            min_y: -100,
            max_x: 100,
            max_y: 100

  @doc ~S"""
  Returns a baseline configuration which can be modified to taste.  Always start
  here and avoid manually building `Config` structs, you can operate knowing all
  `Config`s are valid.
  """
  @spec default() :: t()
  def default, do: %__MODULE__{}

  @doc ~S"""
  Replaces `setting` in `config` with `value`, if legal.  Returns
  `{:ok, updated_config}` when the change is made or `{:error, reason}` when
  the new value doesn't pass validations.  The error `reason` is always given
  in relation to the passed `setting`.

  The pseudo `setting`s `x_limit` and `y_limit` can be given a positive integer
  to use that `value` for the corresponding maximum and the negated `value` for
  the corresponding minimum.
  """
  @spec update(t(), atom(), any()) :: {:ok, t()} | {:error, atom(), String.t()}
  def update(config, setting, value) when setting in ~w[x_limit y_limit]a do
    # errors for the pseudo settings are handled separately, because they
    # cannot be added to the struct normally
    if is_integer(value) and value >= 0 do
      {min, max} =
        case setting do
          :x_limit -> {:min_x, :max_x}
          :y_limit -> {:min_y, :max_y}
        end

      # 1. Add the max, without validation
      # 2. Set the min to see if it will validate with that max
      # 3. Reset the max to see if it will validate with that min
      with config <- struct!(config, [{max, value}]),
           {:ok, config} <- update(config, min, -value) do
        update(config, max, value)
      end
    else
      {:error, "must be a positive integer"}
    end
  end

  def update(config, setting, value) do
    config = struct!(config, [{setting, value}])

    case error_for(setting, value, config) do
      nil ->
        {:ok, config}

      error ->
        {:error, error}
    end
  end

  @spec error_for(atom(), any(), t()) :: String.t() | nil
  defp error_for(setting, value, _config)
       when setting in ~w[sectors min_x max_x min_y max_y]a and
              not is_integer(value) do
    "must be an integer"
  end

  defp error_for(:sectors, sectors, _config) when sectors < 7 do
    "must be at least seven"
  end

  defp error_for(setting, value, %__MODULE__{max_x: max_x, max_y: max_y})
       when (setting == :min_x and value > max_x) or
              (setting == :min_y and value > max_y) do
    "must remain at or below the maximum"
  end

  defp error_for(setting, value, %__MODULE__{min_x: min_x, min_y: min_y})
       when (setting == :max_x and value <= min_x) or
              (setting == :max_y and value <= min_y) do
    "must remain above the minimum"
  end

  defp error_for(setting, _value, %__MODULE__{
         sectors: sectors,
         min_x: min_x,
         max_x: max_x,
         min_y: min_y,
         max_y: max_y
       })
       when setting in ~w[sectors min_x max_x min_y max_y]a and
              sectors > (max_x - min_x + 1) * (max_y - min_y + 1) do
    if setting == :sectors do
      "exceeds coordinate space"
    else
      "won't contain sectors"
    end
  end

  defp error_for(_setting, _value, _config), do: nil
end
