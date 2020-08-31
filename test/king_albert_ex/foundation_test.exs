defmodule KingAlbertEx.FoundationTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Foundation
  alias KingAlbertEx.Position

  test "new" do
    assert Foundation.new(:clubs) == %Position{kind: Foundation, cards: [{0, :clubs}]}
  end

  test "display" do
    assert %Position{kind: Foundation, cards: [{0, :hearts}]} |> Foundation.display() == "  ♡"

    assert %Position{
             kind: Foundation,
             cards: [
               {12, :hearts},
               {11, :hearts},
               {10, :hearts},
               {9, :hearts},
               {10, :hearts},
               {9, :hearts},
               {8, :hearts},
               {7, :hearts},
               {6, :hearts},
               {5, :hearts},
               {4, :hearts},
               {3, :hearts},
               {2, :hearts},
               {1, :hearts},
               {0, :hearts}
             ]
           }
           |> Foundation.display() == " Q♡"
  end

  test "complete" do
    assert %Position{kind: Foundation, cards: [{0, :hearts}]} |> Foundation.complete() == false

    assert %Position{
             kind: Foundation,
             cards: [
               {12, :hearts},
               {11, :hearts},
               {10, :hearts},
               {9, :hearts},
               {10, :hearts},
               {9, :hearts},
               {8, :hearts},
               {7, :hearts},
               {6, :hearts},
               {5, :hearts},
               {4, :hearts},
               {3, :hearts},
               {2, :hearts},
               {1, :hearts},
               {0, :hearts}
             ]
           }
           |> Foundation.complete() == false

    assert %Position{
             kind: Foundation,
             cards: [
               {13, :hearts},
               {12, :hearts},
               {11, :hearts},
               {10, :hearts},
               {9, :hearts},
               {10, :hearts},
               {9, :hearts},
               {8, :hearts},
               {7, :hearts},
               {6, :hearts},
               {5, :hearts},
               {4, :hearts},
               {3, :hearts},
               {2, :hearts},
               {1, :hearts},
               {0, :hearts}
             ]
           }
           |> Foundation.complete() == true
  end

  test "_can_give?" do
    assert %Position{kind: Foundation, cards: [{0, :hearts}]} |> Foundation._can_give?() == false

    assert %Position{kind: Foundation, cards: [{2, :hearts}, {1, :hearts}, {0, :hearts}]}
           |> Foundation._can_give?() == false
  end

  test "_can_receive?" do
    assert %Position{kind: Foundation, cards: [{0, :hearts}]}
           |> Foundation._can_receive?({1, :hearts}) == true

    assert %Position{kind: Foundation, cards: [{0, :hearts}]}
           |> Foundation._can_receive?({1, :diamonds}) == false

    assert %Position{kind: Foundation, cards: [{0, :hearts}]}
           |> Foundation._can_receive?({1, :clubs}) == false

    assert %Position{kind: Foundation, cards: [{2, :hearts}, {1, :hearts}, {0, :hearts}]}
           |> Foundation._can_receive?({3, :hearts}) == true

    assert %Position{kind: Foundation, cards: [{2, :hearts}, {1, :hearts}, {0, :hearts}]}
           |> Foundation._can_receive?({4, :hearts}) == false

    assert %Position{kind: Foundation, cards: [{2, :hearts}, {1, :hearts}, {0, :hearts}]}
           |> Foundation._can_receive?({3, :diamonds}) == false
  end
end
