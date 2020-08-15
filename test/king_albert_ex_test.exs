defmodule KingAlbertExTest do
  use ExUnit.Case
  doctest KingAlbertEx

  test "greets the world" do
    assert KingAlbertEx.hello() == :world
  end
end
