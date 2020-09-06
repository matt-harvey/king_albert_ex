defmodule KingAlbertEx.GameTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Column
  alias KingAlbertEx.Deck
  alias KingAlbertEx.Foundation
  alias KingAlbertEx.Game
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
    game = Game.new(Deck.new())
    assert game == %Game{board: board, messages: [], over: false}
  end

  test "display with no messages", %{board: board} do
    game = %Game{board: board, messages: [], over: false}

    assert Game.display(game) ==
             "\e[2J\e[1;1H
                             a    b    c    d
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

  test "display with messages", %{board: board} do
    game = %Game{board: board, messages: ["Cool", "Yeah nice"], over: false}

    assert Game.display(game) ==
             "\e[2J\e[1;1H
                             a    b    c    d
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
             7♣   8♣   9♣  10♣   J♣   Q♣   K♣
Cool
Yeah nice"
  end

  test "apply 'quit' command", %{board: board} do
    game = %Game{board: board, messages: ["Hi"], over: false}

    assert Game.apply(game, "quit") == %Game{
             board: board,
             messages: ["Hi", "> quit", "Bye!"],
             over: true
           }
  end

  test "apply 'help' command", %{board: board} do
    game = %Game{board: board, messages: ["Hi"], over: false}

    assert Game.apply(game, "help") == %Game{
             board: board,
             messages: [
               "Hi",
               "> help",
               ~s{Enter two letters to describe your move, indicating the "from" position and the "to" position.\nFor full rules, enter "rules". To quit, enter "quit".\n}
             ],
             over: false
           }
  end

  test "apply 'rules' command", %{board: board} do
    game = %Game{board: board, messages: ["Hi"], over: false}

    assert Game.apply(game, "rules") == %Game{
             board: board,
             messages: [
               "Hi",
               "> rules",
               """
               The game board consists of four Foundations (labelled a to d), nine Columns (e to m), and a Reserve (n to t).
               The aim of the game is to complete the Foundations in ascending order, from Ace through to King in each suit.
               In each Column, only the last card (nearer the bottom of the screen) is available for play.
               All cards in the Reserve are available to play; however cards cannot be moved back into the Reserve once played.
               Any empty Foundation can be filled with the Ace of its suit; and thereafter each Foundation must then be built up
               in ascending sequence from 2 through to King.
               Cards can be played to Columns only one at a time, in descending order in alternating colours. For example,
               if the last card in a Column is a 4\u2661, then either the 3\u2663 or the 3\u2660 could be added.
               You have won when the top card of each Foundation is a King.
               """
             ],
             over: false
           }
  end

  test "apply a well-formed valid move command that neither wins nor loses the game", %{
    board: board
  } do
    game = %Game{board: board, messages: ["Hi"], over: false}

    new_board = [
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

    assert Game.apply(game, "ea") == %Game{
             board: new_board,
             messages: [],
             over: false
           }
  end

  test "apply a well-formed valid move command that wins the game" do
    board = [
      %Position{
        kind: Foundation,
        cards: [
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
      %Position{kind: Column, cards: [{13, :spades}]},
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

    game = %Game{board: board, messages: ["Hi"], over: false}

    new_board = [
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

    assert Game.apply(game, "ea") == %Game{
             board: new_board,
             messages: ["You won! Congratulations."],
             over: true
           }
  end

  test "apply a well-formed valid move command that loses the game" do
    board = [
      %Position{kind: Foundation, cards: [{0, :spades}]},
      %Position{kind: Foundation, cards: [{0, :hearts}]},
      %Position{kind: Foundation, cards: [{0, :diamonds}]},
      %Position{kind: Foundation, cards: [{0, :clubs}]},
      %Position{kind: Column, cards: []},
      %Position{kind: Column, cards: [{5, :spades}, {3, :spades}, {2, :spades}]},
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

    game = %Game{board: board, messages: ["Hi"], over: false}

    new_board = [
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

    assert Game.apply(game, "fe") == %Game{
             board: new_board,
             messages: ["No legal moves are available. You lost."],
             over: true
           }
  end

  test "apply a well-formed invalid move command", %{board: board} do
    game = %Game{board: board, messages: ["Hi"], over: false}

    assert Game.apply(game, "fe") == %Game{
             board: board,
             messages: ["Hi", "> fe", "Invalid move. Try again."],
             over: false
           }
  end

  test "apply an ill-formed command", %{board: board} do
    game = %Game{board: board, messages: ["Hi"], over: false}

    assert Game.apply(game, "yaa") == %Game{
             board: board,
             messages: [
               "Hi",
               "> yaa",
               "Invalid move.",
               """
               Enter two letters to describe your move, indicating the "from" position and the "to" position.
               For full rules, enter "rules". To quit, enter "quit".
               """
             ],
             over: false
           }
  end

  test "over?" do
    assert Game.over?(%Game{over: true})
    assert !Game.over?(%Game{over: false})
  end
end
