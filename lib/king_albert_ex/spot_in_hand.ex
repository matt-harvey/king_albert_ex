defmodule KingAlbertEx.SpotInHand do
  @moduledoc """
  Defines a type representing a single spot in the player's "hand" (also known as the "reserve"), along
  with functions relating to that type. To the player, each such spot can either be occupied a single card,
  or be empty.
  """

  alias KingAlbertEx.Card
  alias KingAlbertEx.Position
  alias KingAlbertEx.SpotInHand

  @behaviour Position

  @type t :: %Position{kind: __MODULE__, cards: []}

  @spec new(Card.t()) :: %Position{kind: __MODULE__, cards: [Card.t()]}
  def new(card), do: %Position{kind: SpotInHand, cards: [card]}

  @spec display(t()) :: String.t()
  def display(%Position{cards: []}), do: "   "
  def display(%Position{cards: [card]}), do: Card.display(card)

  @impl Position
  def _can_give?(%Position{cards: []}), do: false
  def _can_give?(_spot_in_hand), do: true

  @impl Position
  def _can_receive?(_spot_in_hand, _card), do: false
end
