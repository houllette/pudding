defmodule Pudding.Contracts.PathPolicyTest do
  use ExUnit.Case, async: true

  alias Pudding.Contracts.PathPolicy

  @invalid [
    <<>>,
    ".",
    "..",
    "../",
    "/a",
    "a/",
    "a//b",
    "a/./b",
    "a/../b",
    <<0>>,
    <<"a/", 0, "/b">>,
    <<"a", 0, "b">>
  ]

  @valid [
    {"a", ["a"]},
    {"a/b", ["a", "b"]},
    {".../.hidden/a..", ["...", ".hidden", "a.."]},
    {"a\\b/C:/%2e%2e", ["a\\b", "C:", "%2e%2e"]},
    {<<255, 47, 192, 128>>, [<<255>>, <<192, 128>>]},
    {<<10, 13, 9>>, [<<10, 13, 9>>]}
  ]

  test "the byte oracle rejects exact invalid paths" do
    for input <- @invalid do
      assert PathPolicy.expected(input) === {:error, :invalid_path}, inspect(input)
    end
  end

  test "the byte oracle preserves exact useful output without text interpretation" do
    for {input, components} <- @valid do
      assert PathPolicy.expected(input) === {:ok, components}, inspect(input)
    end
  end

  test "slash splitting preserves every empty component, including the empty binary" do
    assert PathPolicy.split_slash(<<>>) === [<<>>]
    assert PathPolicy.split_slash("/a//") === ["", "a", "", ""]
    assert PathPolicy.split_slash(<<255, 47, 0>>) === [<<255>>, <<0>>]
  end

  test "the oracle's wrapper includes nonbyte bitstrings and arbitrary nonbinary terms" do
    for input <- [nil, :path, 12, 1.5, [], [97], {}, %{}, <<1::1>>, <<255, 1::1>>] do
      assert PathPolicy.expected(input) === {:error, :not_binary}, inspect(input)
    end
  end

  test "all single bytes have the exact specified classification" do
    for byte <- 0..255 do
      expected =
        if byte in [0, ?., ?/],
          do: {:error, :invalid_path},
          else: {:ok, [<<byte>>]}

      assert PathPolicy.expected(<<byte>>) === expected
    end
  end
end
