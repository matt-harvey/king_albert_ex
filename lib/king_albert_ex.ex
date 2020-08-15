defmodule KingAlbertEx do
  @moduledoc """
  Entry point for coordinating the running of the application.
  """

  alias KingAlbertEx.Deck
  alias KingAlbertEx.Game

  @prompt "> "

  def main(_args) do
    initial_game_state = create_game()
    initial_game_state |> Game.display() |> IO.puts()

    get_input()
    |> Stream.iterate(fn _ -> get_input() end)
    |> Enum.reduce_while(initial_game_state, fn command, game_state ->
      updated_game_state = Game.apply(game_state, command)
      updated_game_state |> Game.display() |> IO.puts()

      if Game.over?(updated_game_state) do
        {:halt, nil}
      else
        {:cont, updated_game_state}
      end
    end)
  end

  defp create_game() do
    Deck.new() |> Deck.shuffle() |> Game.new(@prompt)
  end

  defp get_input() do
    @prompt |> IO.gets() |> String.trim()
  end
end
