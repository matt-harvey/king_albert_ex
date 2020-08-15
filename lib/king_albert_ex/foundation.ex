defmodule KingAlbertEx.Foundation do
  @moduledoc """
  Defines a type representing a stack of 1 or more cards built up in ascending order in a particular suit.
  (The object of the game is to "complete" each foundation by building up to the King of that suit.)
  The first card is always the "0" rank card of its suit (which is a "notional" i.e. "non-playable" card).
  """

  alias KingAlbertEx.Foundation
  alias KingAlbertEx.Card
  alias KingAlbertEx.Rank
  alias KingAlbertEx.Suit
  alias KingAlbertEx.Position

  @behaviour Position

  @type t() :: %Position{kind: Foundation, cards: [Card.t()]}

  @spec new(Suit.t()) :: %Position{kind: Foundation, cards: [{0, Suit.t()}]}
  def new(suit), do: %Position{kind: Foundation, cards: [{0, suit}]}

  @spec display(t()) :: String.t()
  def display(%Position{kind: Foundation, cards: [top_card | _rest]}), do: Card.display(top_card)

  @spec complete(t()) :: boolean
  def complete(%Position{kind: Foundation, cards: [{top_card_rank, _suit} | _rest]}) do
    top_card_rank == Rank.max()
  end

  @impl Position
  def _can_give?(_foundation), do: false

  @impl Position
  def _can_receive?(
        %Position{kind: Foundation, cards: [{top_card_rank, top_card_suit} | _rest]},
        {new_card_rank, new_card_suit}
      ) do
    new_card_suit == top_card_suit && new_card_rank == Rank.next(top_card_rank)
  end
end
