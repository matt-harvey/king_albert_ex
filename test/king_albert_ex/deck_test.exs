defmodule KingAlbertEx.DeckTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Deck

  test "new" do
    deck = Deck.new()
    assert Enum.count(deck) == 52
    assert deck |> Enum.uniq() |> Enum.count() == 52
    assert Enum.take(deck, 1) == [{1, :spades}]
    assert !Enum.any?(deck, fn {rank, _suit} -> rank == 0 end)
  end

  test "shuffle" do
    deck = Deck.new() |> Deck.shuffle()
    assert Enum.count(deck) == 52
    assert deck |> Enum.uniq() |> Enum.count() == 52
    assert !Enum.any?(deck, fn {rank, _suit} -> rank == 0 end)
  end
end
