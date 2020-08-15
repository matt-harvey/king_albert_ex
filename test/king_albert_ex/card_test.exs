defmodule KingAlbertEx.CardTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Card

  test "all_playable" do
    all = Card.all_playable()
    assert Enum.count(all) == 52
    assert all |> Enum.uniq() |> Enum.count() == 52
    assert Enum.take(all, 1) == [{1, :spades}]
  end

  test "color" do
    assert Card.color({3, :spades}) == :black
    assert Card.color({3, :hearts}) == :red
    assert Card.color({3, :diamonds}) == :red
    assert Card.color({3, :clubs}) == :black
  end

  test "display" do
    assert Card.display({0, :hearts}) == "  ♡"
    assert Card.display({12, :hearts}) == " Q♡"
    assert Card.display({10, :hearts}) == "10♡"
  end
end
