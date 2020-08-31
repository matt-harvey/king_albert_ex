defmodule KingAlbertEx.MoveTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Move

  test "from_string" do
    assert Move.from_string("ac") == %Move{origin: 0, destination: 2}
    assert Move.from_string("de") == %Move{origin: 3, destination: 4}
    assert Move.from_string("d") == nil
    assert Move.from_string("deb") == nil
    assert Move.from_string("") == nil
  end
end
