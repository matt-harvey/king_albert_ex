defmodule KingAlbertEx.VictoryState do
  @moduledoc """
  Defines a type representing whether the player has won the game, or has lost the game, or
  whether the game is still ongoing.
  """

  @type t() :: :won | :ongoing | :lost
end
