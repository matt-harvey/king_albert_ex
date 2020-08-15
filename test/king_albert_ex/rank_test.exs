defmodule KingAlbertEx.RankTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Rank

  test "all_playable" do
    assert Rank.all_playable() == 1..13
  end

  test "display" do
    assert Rank.display(0) == "  "
    assert Rank.display(1) == " A"
    assert Rank.display(2) == " 2"
    assert Rank.display(10) == "10"
    assert Rank.display(11) == " J"
    assert Rank.display(12) == " Q"
    assert Rank.display(13) == " K"
  end
end
