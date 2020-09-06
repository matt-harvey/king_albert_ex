defmodule KingAlbertEx.ConfigTest do
  use ExUnit.Case, async: true

  alias KingAlbertEx.Config

  test "prompt" do
    assert Config.prompt() == "> "
  end
end
