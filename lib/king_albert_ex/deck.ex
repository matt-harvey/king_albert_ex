defmodule KingAlbertEx.Deck do
  @moduledoc """
  Defines a type representing a complete deck of 52 playable cards, along with functions relating to that type.
  """

  alias KingAlbertEx.Card

  @type t() :: [Card.t()]

  @spec new() :: t()
  def new(), do: Card.all_playable()

  @spec shuffle(t()) :: t()
  def shuffle(deck), do: Enum.shuffle(deck)
end
