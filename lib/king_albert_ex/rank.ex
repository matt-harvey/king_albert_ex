defmodule KingAlbertEx.Rank do
  @moduledoc """
  Defines a type representing the rank of a card, e.g. Ace, 2, 3, Jack, or etc..
  """

  @typedoc """
  Represents the rank (a.k.a. denomination) of a playing card. Note that in the implementation of the game, an
  empty Foundation of a particular suit is treated as being populated by a single card of that suit, of rank 0.
  This simplifies the implementation considerably. The 0 of each card is referred to as a "non-playable card",
  and cards of rank > 0 are referred to as "playable cards".
  """
  @type t() :: pos_integer()

  @spec all_playable() :: Range.t()
  def all_playable(), do: min_playable()..max()

  @spec display(t) :: String.t()
  def display(0), do: "  "
  def display(1), do: " A"
  def display(10), do: "10"
  def display(11), do: " J"
  def display(12), do: " Q"
  def display(13), do: " K"
  def display(value), do: " #{to_string(value)}"

  @doc """
  Returns the lowest possible rank that is "playable" by the player.
  """
  @spec min_playable() :: t()
  def min_playable, do: 1

  @doc """
  Returns the highest possible rank.
  """
  @spec max() :: t()
  def max, do: 13

  @doc """
  Returns the next highest Rank after the passed Rank, or, if passed nil, returns the lowest possible rank.
  """
  @spec next(t() | nil) :: t()
  def next(rank), do: rank + 1
end
