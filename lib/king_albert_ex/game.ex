defmodule KingAlbertEx.Game do
  @moduledoc """
  This module defines a type representing the total game state at a given point in time, along with functions
  relating to that type. A "game state" here includes everything about the current game: card positions, messages
  to the the user, etc..
  """

  alias KingAlbertEx.Deck
  alias KingAlbertEx.Game
  alias KingAlbertEx.Board
  alias KingAlbertEx.Move

  @clear_screen "\x1b[2J\x1b[1;1H"

  @quit_command "quit"
  @help_command "help"
  @rules_command "rules"

  @help_text """
  Enter two letters to describe your move, indicating the "from" position and the "to" position.
  For full rules, enter "#{@rules_command}". To quit, enter "#{@quit_command}".
  """

  @rules_text """
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

  @opaque t() :: %__MODULE__{
            board: Board.t(),
            messages: [String.t()],
            over: boolean,
            prompt: String.t()
          }
  defstruct board: nil, messages: [], over: false, prompt: ""

  @spec new(Deck.t(), String.t()) :: t()
  def new(shuffled_deck, prompt) do
    board = Board.new(shuffled_deck)
    %Game{board: board, prompt: prompt}
  end

  @spec display(t()) :: String.t()
  def display(%Game{board: board, messages: messages}) do
    Enum.join([@clear_screen, Board.display(board)] ++ messages, "\n")
  end

  @spec apply(t(), String.t()) :: t()
  def apply(%Game{prompt: prompt} = game, command) do
    prompted_message = prompt <> command

    case command do
      @quit_command ->
        handle_quit(game, prompted_message)

      @help_command ->
        handle_help(game, prompted_message)

      @rules_command ->
        handle_rules(game, prompted_message)

      command ->
        case Move.from_string(command) do
          nil -> handle_ill_formed_move(game, prompted_message)
          move -> handle_well_formed_move(game, prompted_message, move)
        end
    end
  end

  @spec over?(t()) :: boolean
  def over?(%Game{over: over}), do: over

  @spec finalize(t()) :: t()
  defp finalize(game), do: %Game{game | over: true}

  @spec update_board(t(), Board.t()) :: t()
  defp update_board(game, board), do: %Game{game | board: board}

  @spec add_messages(t(), [String.t()]) :: t()
  defp add_messages(%Game{messages: messages} = game, extra_messages) do
    %Game{game | messages: messages ++ extra_messages}
  end

  @spec reset_messages(t(), [String.t()]) :: t()
  defp reset_messages(game, messages) do
    %Game{game | messages: messages}
  end

  @spec handle_quit(t(), String.t()) :: t()
  defp handle_quit(game, prompted_message) do
    game |> finalize() |> add_messages([prompted_message, "Bye!"])
  end

  @spec handle_help(t(), String.t()) :: t()
  defp handle_help(game, prompted_message) do
    add_messages(game, [prompted_message, @help_text])
  end

  @spec handle_rules(t(), String.t()) :: t()
  defp handle_rules(game, prompted_message) do
    add_messages(game, [prompted_message, @rules_text])
  end

  @spec handle_ill_formed_move(t(), String.t()) :: t()
  defp handle_ill_formed_move(game, prompted_message) do
    add_messages(game, [prompted_message, "Invalid move.", @help_text])
  end

  @spec handle_well_formed_move(t(), String.t(), Move.t()) :: t()
  defp handle_well_formed_move(%Game{board: board} = game, prompted_message, move) do
    case Board.apply(board, move) do
      nil ->
        add_messages(game, [prompted_message, "Invalid move. Try again."])

      new_board ->
        game = update_board(game, new_board)

        case Board.victory_state(new_board) do
          :won ->
            game |> finalize() |> reset_messages(["You won! Congratulations."])

          :lost ->
            game |> finalize() |> reset_messages(["No legal moves are available. You lost."])

          :ongoing ->
            reset_messages(game, [])
        end
    end
  end
end
