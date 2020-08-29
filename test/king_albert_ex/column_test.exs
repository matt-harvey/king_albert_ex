defmodule KingAlbertEx.ColumnTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Column
  alias KingAlbertEx.Position

  setup do
    column = %Position{
      kind: Column,
      cards: [
        {3, :clubs},
        {1, :hearts},
        {10, :diamonds},
        {13, :spades},
        {12, :hearts},
        {11, :clubs},
        {2, :clubs}
      ]
    }

    {:ok, column: column}
  end

  test "deal", _ do
    deck = [
      {3, :clubs},
      {1, :hearts},
      {10, :diamonds},
      {13, :spades},
      {12, :hearts},
      {11, :clubs},
      {2, :clubs}
    ]

    assert Column.deal(deck, 0) == {%Position{kind: Column, cards: []}, deck}

    assert Column.deal(deck, 80) == {
             %Position{
               kind: Column,
               cards: [
                 {3, :clubs},
                 {1, :hearts},
                 {10, :diamonds},
                 {13, :spades},
                 {12, :hearts},
                 {11, :clubs},
                 {2, :clubs}
               ]
             },
             []
           }

    assert Column.deal(deck, 2) == {
             %Position{kind: Column, cards: [{3, :clubs}, {1, :hearts}]},
             [
               {10, :diamonds},
               {13, :spades},
               {12, :hearts},
               {11, :clubs},
               {2, :clubs}
             ]
           }
  end

  test "displayed_cards", %{column: column} do
    assert Column.displayed_cards(column) == [" 2♣", " J♣", " Q♡", " K♠", "10♢", " A♡", " 3♣"]
  end

  test "_can_give?", %{column: column} do
    assert Column._can_give?(column) == true
    assert Column._can_give?(%Position{kind: Column, cards: []}) == false
  end

  test "_can_receive?", %{column: column} do
    assert Column._can_receive?(column, {2, :hearts}) == true
    assert Column._can_receive?(column, {2, :clubs}) == false
    assert Column._can_receive?(column, {2, :diamonds}) == true
    assert Column._can_receive?(column, {2, :spades}) == false
    assert Column._can_receive?(column, {3, :hearts}) == false
    assert Column._can_receive?(column, {4, :hearts}) == false
    assert Column._can_receive?(column, {1, :clubs}) == false
    assert Column._can_receive?(column, {1, :hearts}) == false
    assert Column._can_receive?(%Position{kind: Column, cards: []}, {9, :clubs}) == true
  end
end
