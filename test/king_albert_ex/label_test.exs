defmodule KingAlbertEx.LabelTest do
  use ExUnit.Case, async: true
  alias KingAlbertEx.Label

  test "new" do
    assert Label.new() == Label.new()
    assert Label.display(Label.new()) == "a"
  end

  test "from_string" do
    label = Label.from_string("m")
    assert Label.display(label) == "m"
  end

  test "display and apply" do
    label = Label.new()
    assert Label.display(label) == "a"
    {strings, label} = Label.apply(label, [1, 2, 3], 2)
    assert strings == [" a", " b", " c"]
    assert Label.display(label) == "d"
    {strings, label} = Label.apply(label, [], 2)
    assert strings == []
    assert Label.display(label) === "d"
  end

  test "to_index" do
    assert Label.to_index(Label.new()) == 0
    assert Label.to_index(Label.from_string("c")) == 2
    assert Label.to_index(Label.from_string("z")) == 25
  end
end
