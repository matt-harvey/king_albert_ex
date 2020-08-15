defmodule KingAlbertEx.Suit do
  @moduledoc """
  Defines a type representing the suit of a playing card, along with functions relating to that type.
  """

  alias KingAlbertEx.Color

  @type t() :: :spades | :hearts | :diamonds | :clubs

  @spec all() :: [t()]
  def all, do: [:spades, :hearts, :diamonds, :clubs]

  @spec display(t()) :: String.t()
  def display(:spades), do: "\u2660"
  def display(:hearts), do: "\u2661"
  def display(:diamonds), do: "\u2662"
  def display(:clubs), do: "\u2663"

  @spec color(t()) :: Color.t()
  def color(:spades), do: :black
  def color(:hearts), do: :red
  def color(:diamonds), do: :red
  def color(:clubs), do: :black
end
