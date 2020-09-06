defmodule KingAlbertEx.BoardTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Board
  alias KingAlbertEx.Column
  alias KingAlbertEx.Deck
  alias KingAlbertEx.Foundation
  alias KingAlbertEx.Move
  alias KingAlbertEx.Position
  alias KingAlbertEx.SpotInHand

  setup do
    board = [
      %Position{kind: Foundation, cards: [{0, :spades}]},
      %Position{kind: Foundation, cards: [{0, :hearts}]},
      %Position{kind: Foundation, cards: [{0, :diamonds}]},
      %Position{kind: Foundation, cards: [{0, :clubs}]},
      %Position{kind: Column, cards: [{1, :spades}]},
      %Position{kind: Column, cards: [{2, :spades}, {3, :spades}]},
      %Position{kind: Column, cards: [{4, :spades}, {5, :spades}, {6, :spades}]},
      %Position{
        kind: Column,
        cards: [{7, :spades}, {8, :spades}, {9, :spades}, {10, :spades}]
      },
      %Position{
        kind: Column,
        cards: [{11, :spades}, {12, :spades}, {13, :spades}, {1, :hearts}, {2, :hearts}]
      },
      %Position{
        kind: Column,
        cards: [
          {3, :hearts},
          {4, :hearts},
          {5, :hearts},
          {6, :hearts},
          {7, :hearts},
          {8, :hearts}
        ]
      },
      %Position{
        kind: Column,
        cards: [
          {9, :hearts},
          {10, :hearts},
          {11, :hearts},
          {12, :hearts},
          {13, :hearts},
          {1, :diamonds},
          {2, :diamonds}
        ]
      },
      %Position{
        kind: Column,
        cards: [
          {3, :diamonds},
          {4, :diamonds},
          {5, :diamonds},
          {6, :diamonds},
          {7, :diamonds},
          {8, :diamonds},
          {9, :diamonds},
          {10, :diamonds}
        ]
      },
      %Position{
        kind: Column,
        cards: [
          {11, :diamonds},
          {12, :diamonds},
          {13, :diamonds},
          {1, :clubs},
          {2, :clubs},
          {3, :clubs},
          {4, :clubs},
          {5, :clubs},
          {6, :clubs}
        ]
      },
      %Position{kind: SpotInHand, cards: [{7, :clubs}]},
      %Position{kind: SpotInHand, cards: [{8, :clubs}]},
      %Position{kind: SpotInHand, cards: [{9, :clubs}]},
      %Position{kind: SpotInHand, cards: [{10, :clubs}]},
      %Position{kind: SpotInHand, cards: [{11, :clubs}]},
      %Position{kind: SpotInHand, cards: [{12, :clubs}]},
      %Position{kind: SpotInHand, cards: [{13, :clubs}]}
    ]

    {:ok, board: board}
  end

  test "new", %{board: board} do
    deck = Deck.new()
    assert Board.new(deck) == board
  end

  test "apply", %{board: board} do
    assert Board.apply(board, %Move{origin: 0, destination: 1}) == nil
    assert Board.apply(board, %Move{origin: 6, destination: 8}) == nil

    assert Board.apply(board, %Move{origin: 4, destination: 0}) == [
             %Position{kind: Foundation, cards: [{1, :spades}, {0, :spades}]},
             %Position{kind: Foundation, cards: [{0, :hearts}]},
             %Position{kind: Foundation, cards: [{0, :diamonds}]},
             %Position{kind: Foundation, cards: [{0, :clubs}]},
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: [{2, :spades}, {3, :spades}]},
             %Position{kind: Column, cards: [{4, :spades}, {5, :spades}, {6, :spades}]},
             %Position{
               kind: Column,
               cards: [{7, :spades}, {8, :spades}, {9, :spades}, {10, :spades}]
             },
             %Position{
               kind: Column,
               cards: [{11, :spades}, {12, :spades}, {13, :spades}, {1, :hearts}, {2, :hearts}]
             },
             %Position{
               kind: Column,
               cards: [
                 {3, :hearts},
                 {4, :hearts},
                 {5, :hearts},
                 {6, :hearts},
                 {7, :hearts},
                 {8, :hearts}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {9, :hearts},
                 {10, :hearts},
                 {11, :hearts},
                 {12, :hearts},
                 {13, :hearts},
                 {1, :diamonds},
                 {2, :diamonds}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {3, :diamonds},
                 {4, :diamonds},
                 {5, :diamonds},
                 {6, :diamonds},
                 {7, :diamonds},
                 {8, :diamonds},
                 {9, :diamonds},
                 {10, :diamonds}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {11, :diamonds},
                 {12, :diamonds},
                 {13, :diamonds},
                 {1, :clubs},
                 {2, :clubs},
                 {3, :clubs},
                 {4, :clubs},
                 {5, :clubs},
                 {6, :clubs}
               ]
             },
             %Position{kind: SpotInHand, cards: [{7, :clubs}]},
             %Position{kind: SpotInHand, cards: [{8, :clubs}]},
             %Position{kind: SpotInHand, cards: [{9, :clubs}]},
             %Position{kind: SpotInHand, cards: [{10, :clubs}]},
             %Position{kind: SpotInHand, cards: [{11, :clubs}]},
             %Position{kind: SpotInHand, cards: [{12, :clubs}]},
             %Position{kind: SpotInHand, cards: [{13, :clubs}]}
           ]
  end

  test "playable?", %{board: board} do
    assert Board.playable?(board)

    assert !Board.playable?([
             %Position{kind: Foundation, cards: [{0, :spades}]},
             %Position{kind: Foundation, cards: [{0, :hearts}]},
             %Position{kind: Foundation, cards: [{0, :diamonds}]},
             %Position{kind: Foundation, cards: [{0, :clubs}]},
             %Position{kind: Column, cards: [{5, :spades}]},
             %Position{kind: Column, cards: [{3, :spades}, {2, :spades}]},
             %Position{kind: Column, cards: [{4, :spades}, {1, :spades}, {6, :spades}]},
             %Position{
               kind: Column,
               cards: [{10, :spades}, {8, :spades}, {9, :spades}, {7, :spades}]
             },
             %Position{
               kind: Column,
               cards: [{13, :spades}, {12, :spades}, {11, :spades}, {1, :hearts}, {2, :hearts}]
             },
             %Position{
               kind: Column,
               cards: [
                 {7, :hearts},
                 {12, :clubs},
                 {4, :hearts},
                 {5, :hearts},
                 {6, :hearts},
                 {3, :hearts}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {13, :hearts},
                 {10, :hearts},
                 {11, :hearts},
                 {12, :hearts},
                 {9, :hearts},
                 {1, :diamonds},
                 {2, :diamonds}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {13, :diamonds},
                 {4, :diamonds},
                 {5, :diamonds},
                 {6, :diamonds},
                 {7, :diamonds},
                 {8, :diamonds},
                 {9, :diamonds},
                 {10, :diamonds}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {13, :clubs},
                 {12, :diamonds},
                 {3, :diamonds},
                 {1, :clubs},
                 {2, :clubs},
                 {3, :clubs},
                 {4, :clubs},
                 {5, :clubs},
                 {6, :clubs}
               ]
             },
             %Position{kind: SpotInHand, cards: [{7, :clubs}]},
             %Position{kind: SpotInHand, cards: [{8, :clubs}]},
             %Position{kind: SpotInHand, cards: [{9, :clubs}]},
             %Position{kind: SpotInHand, cards: [{10, :clubs}]},
             %Position{kind: SpotInHand, cards: [{11, :clubs}]},
             %Position{kind: SpotInHand, cards: [{8, :hearts}]},
             %Position{kind: SpotInHand, cards: [{11, :diamonds}]}
           ])
  end

  test "victory_state", %{board: board} do
    assert Board.victory_state(board) == :ongoing

    assert [
             %Position{
               kind: Foundation,
               cards: [
                 {13, :spades},
                 {12, :spades},
                 {11, :spades},
                 {10, :spades},
                 {9, :spades},
                 {10, :spades},
                 {9, :spades},
                 {8, :spades},
                 {7, :spades},
                 {6, :spades},
                 {5, :spades},
                 {4, :spades},
                 {3, :spades},
                 {2, :spades},
                 {1, :spades},
                 {0, :spades}
               ]
             },
             %Position{
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
             },
             %Position{
               kind: Foundation,
               cards: [
                 {13, :diamonds},
                 {12, :diamonds},
                 {11, :diamonds},
                 {10, :diamonds},
                 {9, :diamonds},
                 {10, :diamonds},
                 {9, :diamonds},
                 {8, :diamonds},
                 {7, :diamonds},
                 {6, :diamonds},
                 {5, :diamonds},
                 {4, :diamonds},
                 {3, :diamonds},
                 {2, :diamonds},
                 {1, :diamonds},
                 {0, :diamonds}
               ]
             },
             %Position{
               kind: Foundation,
               cards: [
                 {13, :clubs},
                 {12, :clubs},
                 {11, :clubs},
                 {10, :clubs},
                 {9, :clubs},
                 {10, :clubs},
                 {9, :clubs},
                 {8, :clubs},
                 {7, :clubs},
                 {6, :clubs},
                 {5, :clubs},
                 {4, :clubs},
                 {3, :clubs},
                 {2, :clubs},
                 {1, :clubs},
                 {0, :clubs}
               ]
             },
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: []},
             %Position{kind: Column, cards: []},
             %Position{kind: SpotInHand, cards: []},
             %Position{kind: SpotInHand, cards: []},
             %Position{kind: SpotInHand, cards: []},
             %Position{kind: SpotInHand, cards: []},
             %Position{kind: SpotInHand, cards: []},
             %Position{kind: SpotInHand, cards: []},
             %Position{kind: SpotInHand, cards: []}
           ]
           |> Board.victory_state() == :won

    assert [
             %Position{kind: Foundation, cards: [{0, :spades}]},
             %Position{kind: Foundation, cards: [{0, :hearts}]},
             %Position{kind: Foundation, cards: [{0, :diamonds}]},
             %Position{kind: Foundation, cards: [{0, :clubs}]},
             %Position{kind: Column, cards: [{5, :spades}]},
             %Position{kind: Column, cards: [{3, :spades}, {2, :spades}]},
             %Position{kind: Column, cards: [{4, :spades}, {1, :spades}, {6, :spades}]},
             %Position{
               kind: Column,
               cards: [{10, :spades}, {8, :spades}, {9, :spades}, {7, :spades}]
             },
             %Position{
               kind: Column,
               cards: [{13, :spades}, {12, :spades}, {11, :spades}, {1, :hearts}, {2, :hearts}]
             },
             %Position{
               kind: Column,
               cards: [
                 {7, :hearts},
                 {12, :clubs},
                 {4, :hearts},
                 {5, :hearts},
                 {6, :hearts},
                 {3, :hearts}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {13, :hearts},
                 {10, :hearts},
                 {11, :hearts},
                 {12, :hearts},
                 {9, :hearts},
                 {1, :diamonds},
                 {2, :diamonds}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {13, :diamonds},
                 {4, :diamonds},
                 {5, :diamonds},
                 {6, :diamonds},
                 {7, :diamonds},
                 {8, :diamonds},
                 {9, :diamonds},
                 {10, :diamonds}
               ]
             },
             %Position{
               kind: Column,
               cards: [
                 {13, :clubs},
                 {12, :diamonds},
                 {3, :diamonds},
                 {1, :clubs},
                 {2, :clubs},
                 {3, :clubs},
                 {4, :clubs},
                 {5, :clubs},
                 {6, :clubs}
               ]
             },
             %Position{kind: SpotInHand, cards: [{7, :clubs}]},
             %Position{kind: SpotInHand, cards: [{8, :clubs}]},
             %Position{kind: SpotInHand, cards: [{9, :clubs}]},
             %Position{kind: SpotInHand, cards: [{10, :clubs}]},
             %Position{kind: SpotInHand, cards: [{11, :clubs}]},
             %Position{kind: SpotInHand, cards: [{8, :hearts}]},
             %Position{kind: SpotInHand, cards: [{11, :diamonds}]}
           ]
           |> Board.victory_state() == :lost
  end

  test "display", %{board: board} do
    # Note this appears here to be misaligned on the first line only because of quote.
    assert Board.display(board) ===
             "                             a    b    c    d
----------------------------------------------
                             ♠    ♡    ♢    ♣

    e    f    g    h    i    j    k    l    m
----------------------------------------------
   A♠   3♠   6♠  10♠   2♡   8♡   2♢  10♢   6♣
        2♠   5♠   9♠   A♡   7♡   A♢   9♢   5♣
             4♠   8♠   K♠   6♡   K♡   8♢   4♣
                  7♠   Q♠   5♡   Q♡   7♢   3♣
                       J♠   4♡   J♡   6♢   2♣
                            3♡  10♡   5♢   A♣
                                 9♡   4♢   K♢
                                      3♢   Q♢
                                           J♢

              n    o    p    q    r    s    t
----------------------------------------------
             7♣   8♣   9♣  10♣   J♣   Q♣   K♣"
  end
end
