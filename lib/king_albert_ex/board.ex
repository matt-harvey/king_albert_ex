defmodule KingAlbertEx.Board do
  @moduledoc """
  A Board represents the positions of all the cards on the "table" at a given point in time.
  This module includes functions for creating, manipulating and querying a Board, as well
  as displaying it to the user.
  """

  # TODO Consider separating board display logic into a separate module.

  alias KingAlbertEx.Board
  alias KingAlbertEx.Column
  alias KingAlbertEx.Deck
  alias KingAlbertEx.Foundation
  alias KingAlbertEx.Label
  alias KingAlbertEx.Move
  alias KingAlbertEx.Position
  alias KingAlbertEx.SpotInHand
  alias KingAlbertEx.Suit
  alias KingAlbertEx.Util
  alias KingAlbertEx.VictoryState

  @blank "   "
  @gutter "  "

  @num_foundations Enum.count(Suit.all())
  @num_columns 9

  @opaque t :: [Position.t()]

  @spec new(Deck.t()) :: Board.t()
  def new(deck) do
    foundations = Enum.map(Suit.all(), &Foundation.new(&1))

    {columns, deck} =
      Enum.map_reduce(1..@num_columns, deck, fn num_cards, deck ->
        Column.deal(deck, num_cards)
      end)

    hand = Enum.map(deck, &SpotInHand.new(&1))

    foundations ++ columns ++ hand
  end

  @doc """
  Applies a Move to the Board, returning the new, updated Board, or, if the Move is not permitted, nil.
  """
  @spec apply(t(), Move.t()) :: t() | nil
  def apply(positions, %Move{origin: origin, destination: destination}) do
    [{origin_index, origin_position}, {destination_index, destination_position}] =
      Enum.map([origin, destination], fn label ->
        index = Label.to_index(label)
        {index, Enum.at(positions, index)}
      end)

    if Position.can_give?(origin_position) do
      {revised_origin_position, card} = Position.give(origin_position)

      if Position.can_receive?(destination_position, card) do
        revised_destination_position = Position.receive(destination_position, card)

        positions
        |> List.replace_at(origin_index, revised_origin_position)
        |> List.replace_at(destination_index, revised_destination_position)
      end
    end
  end

  @spec playable?(t()) :: boolean
  def playable?(positions) do
    Enum.any?(positions, fn origin_position ->
      if Position.can_give?(origin_position) do
        {_revised_origin_position, card} = Position.give(origin_position)
        Enum.any?(positions, &Position.can_receive?(&1, card))
      else
        false
      end
    end)
  end

  @spec victory_state(t()) :: VictoryState.t()
  def victory_state(board) do
    {foundations, _columns, _hand} = decompose(board)

    cond do
      Enum.all?(foundations, &Foundation.complete(&1)) -> :won
      playable?(board) -> :ongoing
      true -> :lost
    end
  end

  @spec display(t()) :: String.t()
  def display(board) do
    {foundations, columns, hand} = decompose(board)
    label = Label.new()

    # Foundations
    displayed_foundations = Enum.map(foundations, &Foundation.display(&1))
    {labelled_printable_foundations, label} = labelled_printable_row(label, displayed_foundations)

    # Columns
    raw_columns = Enum.map(columns, &Column.displayed_cards(&1))
    {displayed_column_labels, label} = Label.apply(label, columns, column_width())
    num_column_rows = raw_columns |> Enum.map(&Enum.count(&1)) |> Enum.max()

    {column_rows, _} =
      Enum.reduce(1..num_column_rows, {[], raw_columns}, fn _n, {rows, reduced_columns} ->
        {row, updated_reduced_columns} = printable_column_row(reduced_columns)
        {[row | rows], updated_reduced_columns}
      end)

    printable_column_rows = column_rows |> Enum.reverse() |> Enum.join("\n")
    printable_column_labels = printable_row(displayed_column_labels)

    labelled_printable_columns =
      Enum.join([printable_column_labels, calculate_divider(), printable_column_rows], "\n")

    # Hand
    displayed_hand = Enum.map(hand, &SpotInHand.display(&1))
    {labelled_printable_hand, _label} = labelled_printable_row(label, displayed_hand)

    # Put it together
    [labelled_printable_foundations, "", labelled_printable_columns, "", labelled_printable_hand]
    |> Enum.join("\n")
  end

  # A dividing line for printing in the middle of the board, that will go across the whole board.
  @spec calculate_divider() :: String.t()
  defp calculate_divider() do
    "-" |> Util.repeat(calculate_width()) |> Enum.join("")
  end

  @spec calculate_width() :: pos_integer
  defp calculate_width() do
    gutter_width = String.length(@gutter)
    @num_columns * (column_width() + gutter_width) + 1
  end

  @spec column_width() :: pos_integer
  defp column_width(), do: String.length(@blank)

  @spec decompose(t()) :: {[Foundation.t()], [Column.t()], [SpotInHand.t()]}
  defp decompose(positions) do
    {foundations, positions} = Enum.split(positions, @num_foundations)
    {columns, hand} = Enum.split(positions, @num_columns)
    {foundations, columns, hand}
  end

  @spec labelled_printable_row(Label.t(), [String.t()]) :: {String.t(), Label.t()}
  defp labelled_printable_row(first_label, cells) do
    {label_cells, next_label} = Label.apply(first_label, cells, column_width())
    label_row = printable_row(label_cells)
    content_row = printable_row(cells)
    {Enum.join([label_row, calculate_divider(), content_row], "\n"), next_label}
  end

  # Where each of the passed strings is a "cell" of printable content, returns
  # a right-aligned string in which the cells are displayed each aligned in its
  # own "column".
  @spec printable_row([String.t()]) :: String.t()
  defp printable_row(cells) do
    num_blank_cells_required = @num_columns - Enum.count(cells)
    blank_cells = Util.repeat(@blank, num_blank_cells_required)
    Enum.join(["" | blank_cells] ++ cells, @gutter)
  end

  # Receives a list of "columns" (lists-of-"cells"), such each column may be of differing length,
  # and returns a tuple comprising the first cell in each column (or a blank space if the column is empty),
  # and an updated version of the list of columns, viz. that list but with the first card of each
  # column removed (or the column unadjusted if is already empty).
  @spec printable_column_row([[String.t()]]) :: {String.t(), [[String.t()]]}
  defp printable_column_row(columns) do
    [cells, columns] =
      columns
      |> Enum.map(fn column ->
        case column do
          [] -> [@blank, []]
          [card | rest] -> [card, rest]
        end
      end)
      |> Enum.zip()

    row_as_list = Tuple.to_list(cells)
    row = printable_row(row_as_list)
    reduced_columns = Tuple.to_list(columns)
    {row, reduced_columns}
  end
end
