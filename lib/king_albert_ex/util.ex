defmodule KingAlbertEx.Util do
  @moduledoc """
  Contains general utility functions.
  """

  @doc """
  Returns a List in which x is repeated n times.
  """
  @spec repeat(any(), non_neg_integer()) :: [any()]
  def repeat(_x, 0), do: []
  def repeat(x, times), do: 1..times |> Enum.map(fn _ -> x end)
end
