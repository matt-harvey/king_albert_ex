defmodule KingAlbertEx.Card do
  @moduledoc """
  Defines a type representing a playing card, along with functions relating to that type.
  """

  alias KingAlbertEx.Color
  alias KingAlbertEx.Rank
  alias KingAlbertEx.Suit

  @typedoc """
  Represents a playing card. Note that in the implementation of the game, an empty Foundation of a particular
  suit is treated as being populated by a single card of that suit, of rank 0. This simplifies the implementation
  considerably. The 0 of each card is referred to as a "non-playable card", and cards of rank > 0 are referred to
  as "playable cards".
  """
  @type t() :: {Rank.t(), Suit.t()}

  @spec all_playable() :: [t()]
  def all_playable(), do: Enum.flat_map(Suit.all(), &all_playable_for_suit(&1))

  @spec color(t()) :: Color.t()
  def color({_rank, suit}), do: Suit.color(suit)

  @spec display(t()) :: String.t()
  def display({rank, suit}), do: Rank.display(rank) <> Suit.display(suit)

  @spec all_playable_for_suit(Suit.t()) :: [t()]
  defp all_playable_for_suit(suit), do: Enum.map(Rank.all_playable(), &{&1, suit})
end
