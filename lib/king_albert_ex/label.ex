defmodule KingAlbertEx.Label do
  @moduledoc """
  Defines a type representing a single-character alphabetical label for presentation to the
  user, for pointing or referring to a particular card Position during the course of the game.
  """

  @opaque t :: non_neg_integer

  @spec new() :: t()
  def new(), do: 0

  @spec from_string(String.t()) :: t()
  def from_string(<<char_code::utf8>>), do: char_code - offset()

  @doc """
  Returns a series of distinct strings, starting with the passed label as a string, one for each
  element of the enumerable, together with the next value for the label. Each label is left-padded
  to be the width of left_pad.
  """
  @spec apply(t(), Enum.t(), non_neg_integer) :: {[String.t()], t()}
  def apply(label, enumerable, left_pad) do
    {strings, next_label} =
      Enum.reduce(enumerable, {[], label}, fn _member, {strings, next_label} ->
        displayed_label = next_label |> display() |> String.pad_leading(left_pad)
        updated_strings = [displayed_label | strings]
        {updated_strings, next_label + 1}
      end)

    {Enum.reverse(strings), next_label}
  end

  @spec display(t()) :: String.t()
  def display(label) do
    char_code = label + offset()
    <<char_code::utf8>>
  end

  @spec to_index(t()) :: non_neg_integer
  def to_index(label), do: label

  @spec offset() :: non_neg_integer
  defp offset(), do: ?a
end
