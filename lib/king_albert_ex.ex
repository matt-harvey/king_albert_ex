defmodule KingAlbertEx do
  @moduledoc """
  Entry point for coordinating the running of the application.
  """

  alias KingAlbertEx.Config
  alias KingAlbertEx.Deck
  alias KingAlbertEx.Game

  def main(_args) do
    create_game() |> show_game() |> play()
  end

  @spec play(Game.t()) :: nil
  defp play(game) do
    unless Game.over?(game) do
      Game.apply(game, get_input()) |> show_game() |> play()
    end
  end

  @spec show_game(Game.t()) :: Game.t()
  defp show_game(game) do
    game |> Game.display() |> IO.puts()
    game
  end

  @spec create_game() :: Game.t()
  defp create_game() do
    Deck.new() |> Deck.shuffle() |> Game.new()
  end

  @spec get_input() :: String.t()
  defp get_input() do
    Config.prompt() |> IO.gets() |> String.trim()
  end
end
