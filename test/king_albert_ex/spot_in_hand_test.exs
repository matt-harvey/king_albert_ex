defmodule KingAlbertEx.SpotInHandTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Position
  alias KingAlbertEx.SpotInHand

  test "new" do
    assert SpotInHand.new({2, :spades}) == %Position{kind: SpotInHand, cards: [{2, :spades}]}
  end

  test "display" do
    assert %Position{kind: SpotInHand, cards: [{10, :hearts}]} |> SpotInHand.display() == "10♡"
    assert %Position{kind: SpotInHand, cards: [{11, :hearts}]} |> SpotInHand.display() == " J♡"
    assert %Position{kind: SpotInHand, cards: []} |> SpotInHand.display() == "   "
  end

  test "_can_give?" do
    assert %Position{kind: SpotInHand, cards: [{11, :hearts}]} |> SpotInHand._can_give?() == true
    assert %Position{kind: SpotInHand, cards: []} |> SpotInHand._can_give?() == false
  end

  test "_can_receive?" do
    assert %Position{kind: SpotInHand, cards: [{11, :hearts}]}
           |> SpotInHand._can_receive?({12, :hearts}) == false

    assert %Position{kind: SpotInHand, cards: [{11, :hearts}]}
           |> SpotInHand._can_receive?({10, :clubs}) == false

    assert %Position{kind: SpotInHand, cards: []} |> SpotInHand._can_receive?({1, :spades}) ==
             false
  end
end
