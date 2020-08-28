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
  Returns a series of distinct formatted labels, starting with the passed label as a string, one for each
  element of the list, together with the next value for the label. Each label is left-padded
  to be left_pad wide.
  """
  @spec apply(t(), list, non_neg_integer) :: {[String.t()], t()}
  def apply(label, list, left_pad) do
    {strings, next_label} = apply(label, list, left_pad, [])
    {Enum.reverse(strings), next_label}
  end

  @spec apply(t(), list, non_neg_integer, [String.t()]) :: {[String.t()], t()}
  defp apply(label, [], _left_pad, label_strings), do: {label_strings, label}

  defp apply(label, list, left_pad, label_strings) do
    displayed_label = label |> display() |> String.pad_leading(left_pad)
    apply(label + 1, Enum.drop(list, 1), left_pad, [displayed_label | label_strings])
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
