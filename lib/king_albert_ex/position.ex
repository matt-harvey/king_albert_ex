defmodule KingAlbertEx.Position do
  alias KingAlbertEx.Card
  alias KingAlbertEx.Position

  @moduledoc """
  A Position is a place on the table that can be occupied by 0 or more cards.
  There are different kinds of position, that have different rules about when cards can
  be moved to and from a Position. Gameplay consists in the moving of cards by the player between
  Positions.
  """

  @type t() :: %__MODULE__{kind: atom(), cards: [Card.t()]}
  defstruct kind: nil, cards: []

  @doc """
  Removes the top Card from the Position.
  """
  @spec give(t()) :: {t(), Card.t()}
  def give(%Position{cards: [top_card | rest]} = position) do
    {%Position{position | cards: rest}, top_card}
  end

  @doc """
  Adds a Card to the top of the Position.
  """
  @spec receive(t(), Card.t()) :: t()
  def receive(%Position{cards: cards} = position, card) do
    %Position{position | cards: [card | cards]}
  end

  @doc """
  Returns true only if it's permitted for the player to take a Card from this Position.
  """
  @spec can_give?(t()) :: boolean
  def can_give?(%Position{kind: kind} = position) do
    kind._can_give?(position)
  end

  @doc """
  Returns true only if it's permitted for the player to add the passed Card to the top of this Position.
  """
  @spec can_receive?(t(), Card.t()) :: boolean
  def can_receive?(%Position{kind: kind} = position, card) do
    kind._can_receive?(position, card)
  end

  @callback _can_give?(t()) :: boolean
  @callback _can_receive?(t(), Card.t()) :: boolean
end
