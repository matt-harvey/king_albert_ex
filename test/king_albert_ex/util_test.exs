defmodule KingAlbertEx.UtilTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Util

  test "repeat" do
    assert Util.repeat(3, 5) == [3, 3, 3, 3, 3]
    assert Util.repeat(9, 0) == []
    assert Util.repeat([], 2) == [[], []]
  end
end
