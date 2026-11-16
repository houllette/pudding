defmodule ArchivePath.ContractTest do
  use ExUnit.Case, async: true

  alias ArchivePath.{Fixed, Laws, Vulnerable, VulnerableLaws}
  alias Pudding.Contracts.PathPolicy

  test "the fixed fixture and oracle satisfy exact boundary cases" do
    cases = [
      {"", {:error, :invalid_path}},
      {".", {:error, :invalid_path}},
      {"..", {:error, :invalid_path}},
      {"../", {:error, :invalid_path}},
      {"/a", {:error, :invalid_path}},
      {"a/", {:error, :invalid_path}},
      {"a//b", {:error, :invalid_path}},
      {"a/./b", {:error, :invalid_path}},
      {"a/../b", {:error, :invalid_path}},
      {"a/..", {:error, :invalid_path}},
      {<<0>>, {:error, :invalid_path}},
      {<<"a/", 0, "/b">>, {:error, :invalid_path}},
      {<<"a", 0, "b">>, {:error, :invalid_path}},
      {"a/b", {:ok, ["a", "b"]}},
      {".../.hidden/a..", {:ok, ["...", ".hidden", "a.."]}},
      {"a\\b/C:/%2e%2e", {:ok, ["a\\b", "C:", "%2e%2e"]}},
      {<<255, 47, 192, 128>>, {:ok, [<<255>>, <<192, 128>>]}}
    ]

    for {input, expected} <- cases do
      assert Fixed.validate(input) === expected, inspect(input)
      assert PathPolicy.expected(input) === expected, inspect(input)
      assert Laws.binary_contract(input) === true
    end
  end

  test "the synthetic defect is a real BEAM mismatch, not a failed proof" do
    assert Vulnerable.validate("../") === {:error, :invalid_path}
    assert Vulnerable.validate("..") === {:ok, [".."]}
    assert Vulnerable.validate("a/..") === {:ok, ["a", ".."]}
    assert Fixed.validate("..") === {:error, :invalid_path}
    assert PathPolicy.expected("..") === {:error, :invalid_path}

    assert_raise RuntimeError, ~r/expects returned false/, fn ->
      VulnerableLaws.binary_contract("..")
    end
  end

  test "all nonbinary wrapper examples include nonbyte bitstrings" do
    for input <- [nil, false, 0, 1.5, [], [97], {}, %{}, self(), make_ref(), & &1] do
      assert Fixed.validate(input) === {:error, :not_binary}
      assert Vulnerable.validate(input) === {:error, :not_binary}
      assert Laws.nonbinary_wrapper(input) === true
    end

    for width <- 1..7, input <- [<<1::size(width)>>, <<255, 1::size(width)>>] do
      refute is_binary(input)
      assert Fixed.validate(input) === {:error, :not_binary}
      assert Laws.nonbinary_wrapper(input) === true
    end
  end

  test "finite differential corpus covers all single bytes and representative triples" do
    for byte <- 0..255 do
      assert Fixed.validate(<<byte>>) === PathPolicy.expected(<<byte>>)
      assert Fixed.validate(<<97, 47, byte>>) === PathPolicy.expected(<<97, 47, byte>>)
      assert Fixed.validate(<<byte, 47, 98>>) === PathPolicy.expected(<<byte, 47, 98>>)
    end

    for a <- [0, 46, 47, 58, 92, 97, 128, 255],
        b <- [0, 46, 47, 58, 92, 97, 128, 255],
        c <- [0, 46, 47, 58, 92, 97, 128, 255] do
      assert Fixed.validate(<<a, b, c>>) === PathPolicy.expected(<<a, b, c>>)
    end
  end

  test "useful acceptance and exact components rule out reject-all and sanitization" do
    reject_all = fn _input -> {:error, :invalid_path} end
    sanitized = fn _input -> {:ok, ["safe"]} end

    assert_raise RuntimeError, ~r/expects returned false/, fn ->
      ArchivePath.RejectAllLaws.binary_contract("a/b")
    end

    assert_raise RuntimeError, ~r/expects returned false/, fn ->
      ArchivePath.SanitizedLaws.binary_contract("a/b")
    end

    assert PathPolicy.expected("a/b") === {:ok, ["a", "b"]}
    refute reject_all.("a/b") === PathPolicy.expected("a/b")
    refute sanitized.("a/b") === PathPolicy.expected("a/b")
    refute sanitized.("..") === PathPolicy.expected("..")
  end

  test "a validity precondition hides malicious inputs and is not the binary domain" do
    stronger_requires = fn input -> match?({:ok, _}, PathPolicy.expected(input)) end
    assert is_binary("..")
    refute stronger_requires.("..")
    assert is_binary("")
    refute stronger_requires.("")

    assert_raise ArgumentError, ~r/requires returned false/, fn ->
      Laws.binary_contract(<<1::1>>)
    end

    assert_raise ArgumentError, ~r/requires returned false/, fn ->
      Laws.nonbinary_wrapper("valid")
    end

    assert ArchivePath.StrongerPreconditionLaws.binary_contract("a/b") === true

    assert_raise ArgumentError, ~r/requires returned false/, fn ->
      ArchivePath.StrongerPreconditionLaws.binary_contract("..")
    end

    # The actual binary law evaluates, rather than excludes, malicious input.
    assert Laws.binary_contract("..") === true
  end

  test "required law inventory has exactly the full binary and separate wrapper predicates" do
    laws = Laws.__info__(:attributes) |> Keyword.get_values(:law) |> List.flatten()

    assert Enum.map(laws, & &1.name) |> Enum.sort() ==
             [{:binary_contract, [:input]}, {:nonbinary_wrapper, [:input]}]

    assert Enum.map(laws, & &1.requires) |> Enum.sort() ==
             [:"binary_contract:requires", :"nonbinary_wrapper:requires"]

    assert Enum.map(laws, & &1.ensures) |> Enum.sort() ==
             [:"binary_contract:ensures", :"nonbinary_wrapper:ensures"]
  end
end
