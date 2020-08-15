defmodule KingAlbertEx.SuitTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Suit

  test "all" do
    assert Suit.all() == [:spades, :hearts, :diamonds, :clubs]
  end

  test "display" do
    assert Suit.display(:spades) == "♠"
    assert Suit.display(:hearts) == "♡"
    assert Suit.display(:diamonds) == "♢"
    assert Suit.display(:clubs) == "♣"
  end

  test "color" do
    assert Suit.color(:spades) == :black
    assert Suit.color(:hearts) == :red
    assert Suit.color(:diamonds) == :red
    assert Suit.color(:clubs) == :black
  end
end
