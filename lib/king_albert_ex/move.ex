defmodule KingAlbertEx.Move do
  @moduledoc """
  Defines a type representing the player's moving of a single Card from one Position to another, along
  with functions relating to that type.
  """

  alias KingAlbertEx.Move
  alias KingAlbertEx.Label

  @typedoc """
  A Move is represented by a pair of Labels, one pointing to the origin (the Position the Card
  would be moved from) and one pointing to the destination (the position the Card would be moved
  to).
  """
  @type t :: %__MODULE__{origin: Label.t(), destination: Label.t()}
  defstruct origin: nil, destination: nil

  @doc """
  A Move can be created from a string containing two lower case letters, e.g. "ab", representing
  a move from e.g. the Position labelled "a" to the Position labelled "b". This function
  returns nil for strings not containing two letters; however it's not responsible for assessing
  the validity of Moves thus formed.
  """
  @spec from_string(String.t()) :: t() | nil
  def from_string(string) do
    case String.graphemes(string) do
      [first, second] ->
        %Move{origin: Label.from_string(first), destination: Label.from_string(second)}

      _ ->
        nil
    end
  end
end
