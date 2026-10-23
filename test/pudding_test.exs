defmodule PuddingTest do
  use ExUnit.Case
  doctest Pudding

  test "greets the world" do
    assert Pudding.hello() == :world
  end
end
