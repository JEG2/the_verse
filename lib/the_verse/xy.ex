defmodule TheVerse.XY do
  require Integer

  #        {-1, 1}       {0, 1}
  # {-1, 0}        {0, 0}      {1, 0}
  #        {-1, -1}      {0, -1}

  def new(x, y), do: {x, y}

  def ne({x, y}) when Integer.is_even(y), do: {x, y + 1}
  def ne({x, y}) when Integer.is_odd(y), do: {x + 1, y + 1}
  def e({x, y}), do: {x + 1, y}
  def se({x, y}) when Integer.is_even(y), do: {x, y - 1}
  def se({x, y}) when Integer.is_odd(y), do: {x + 1, y - 1}
  def sw({x, y}) when Integer.is_even(y), do: {x - 1, y - 1}
  def sw({x, y}) when Integer.is_odd(y), do: {x, y - 1}
  def w({x, y}), do: {x - 1, y}
  def nw({x, y}) when Integer.is_even(y), do: {x - 1, y + 1}
  def nw({x, y}) when Integer.is_odd(y), do: {x, y + 1}
end
