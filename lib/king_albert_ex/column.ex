defmodule KingAlbertEx.Column do
  @moduledoc """
  Defines a type representing a vertical column of 0 or more playing cards stacked on top of each
  other, of which there are multiple such columns exposed to the player in the game layout.
  Includes various functions relating to this type.
  """

  alias KingAlbertEx.Card
  alias KingAlbertEx.Column
  alias KingAlbertEx.Position
  alias KingAlbertEx.Rank
  alias KingAlbertEx.Suit

  @behaviour Position

  @type t :: %Position{kind: __MODULE__, cards: [Card.t()]}

  @doc """
  Creates a new Column, by removing num_cards cards from the beginning of deck, and placing them in the Column.
  Returns the column, and the cards remaining in the deck.
  """
  @spec deal([Card.t()], integer()) :: {t(), [Card.t()]}
  def deal(deck, num_cards) do
    {cards_taken, cards_remaining} = Enum.split(deck, num_cards)
    {%Position{kind: Column, cards: cards_taken}, cards_remaining}
  end

  @doc """
  Returns the list of pretty printable cards in the Column, with the *last* card first.
  This is because the column is effectively a stack. But the card at the bottom of the stack,
  which is *last* in the Column's internal cards list, is show at the top of the layout when the
  column is displayed to the user.
  """
  @spec displayed_cards(t()) :: [String.t()]
  def displayed_cards(%Position{cards: cards}) do
    cards |> Enum.reverse() |> Enum.map(&Card.display(&1))
  end

  @impl Position
  def _can_give?(%Position{cards: []}), do: false
  def _can_give?(_position), do: true

  @impl Position
  def _can_receive?(%Position{cards: []}, _card), do: true

  def _can_receive?(
        %Position{cards: [{top_card_rank, top_card_suit} | _rest]},
        {new_card_rank, new_card_suit}
      ) do
    top_card_color = Suit.color(top_card_suit)
    new_card_color = Suit.color(new_card_suit)
    top_card_color != new_card_color && Rank.next(new_card_rank) == top_card_rank
  end
end
