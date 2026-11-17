defmodule Pudding.Project.InputsTest do
  use ExUnit.Case, async: true
  alias Pudding.Project.Inputs

  defp request(root) do
    %{
      "root" => root,
      "project" => "consumer",
      "inputs" => ["consumer"],
      "dependencies" => [],
      "writable_paths" => [],
      "environment" => %{"MIX_ENV" => "prod", "MIX_TARGET" => "host"},
      "roots" => [%{"module" => "Elixir.Target", "function" => "run", "arity" => 1}],
      "laws" => [],
      "unknown_inputs" => []
    }
  end

  @tag :tmp_dir
  test "staging binds generated/config/resource bytes and rejects symlinks including intermediate components",
       %{tmp_dir: dir} do
    File.mkdir_p!(dir <> "/root/consumer/config")
    File.write!(dir <> "/root/consumer/mix.exs", "not evaluated")
    File.write!(dir <> "/root/consumer/config/config.exs", "macro config")
    File.write!(dir <> "/secret", "not authorized")
    File.ln_s!(dir, dir <> "/root/link")
    req = request(dir <> "/root")
    assert {:ok, inventory} = Inputs.stage(req, dir <> "/safe")
    assert inventory["consumer/config/config.exs"]["size"] == 12

    assert {:error, {:unsafe_input, _, :symlink}} =
             Inputs.stage(%{req | "inputs" => ["link/secret"]}, dir <> "/unsafe")

    refute File.exists?(dir <> "/unsafe/link/secret")
    File.ln_s!(dir <> "/secret", dir <> "/root/consumer/resource")
    assert {:error, {:unsafe_input, _, :symlink}} = Inputs.stage(req, dir <> "/leaf")
  end

  @tag :tmp_dir
  test "staging refuses recursive destinations and oversized host inputs before copying", %{
    tmp_dir: dir
  } do
    File.mkdir_p!(dir <> "/consumer")
    req = request(dir)
    assert {:error, :output_overlaps_input} = Inputs.stage(req, dir <> "/consumer/capture")
    refute File.exists?(dir <> "/consumer/capture")

    File.open!(dir <> "/consumer/large", [:write], fn file ->
      :file.position(file, 134_217_728)
      IO.binwrite(file, "x")
    end)

    assert {:error, :input_size_or_count_limit} = Inputs.stage(req, dir <> "/staging")
    refute File.exists?(dir <> "/staging")
  end

  @tag :tmp_dir
  test "output aliases, git indirection, alternate stores and oversized metadata fail closed", %{
    tmp_dir: dir
  } do
    File.mkdir_p!(dir <> "/root/consumer")
    File.ln_s!(dir <> "/root", dir <> "/alias")

    assert {:error, :symlink_output_ancestor} =
             Inputs.stage(request(dir <> "/root"), dir <> "/alias/output")

    refute File.exists?(dir <> "/root/output")
    File.mkdir_p!(dir <> "/dep")

    dep = %{
      "kind" => "git",
      "source" => dir <> "/dep",
      "destination" => "deps/example",
      "revision" => String.duplicate("a", 40),
      "url" => "https://example.invalid/repo"
    }

    req = Map.put(request(dir <> "/root"), "dependencies", [dep])
    File.write!(dir <> "/dep/.git", "gitdir: /unauthorized")
    assert {:error, {:unsafe_git_dependency, _, _}} = Inputs.stage(req, dir <> "/indirection")
    File.rm!(dir <> "/dep/.git")
    File.mkdir_p!(dir <> "/dep/.git/objects/info")
    File.write!(dir <> "/dep/.git/objects/info/alternates", "/unauthorized")
    assert {:error, {:unsafe_git_dependency, _, _}} = Inputs.stage(req, dir <> "/alternates")

    File.open!(dir <> "/dep/.git/large", [:write], fn file ->
      :file.position(file, 134_217_728)
      IO.binwrite(file, "x")
    end)

    assert {:error, :input_size_or_count_limit} = Inputs.stage(req, dir <> "/large")
    refute File.exists?(dir <> "/large")
  end

  @tag :tmp_dir
  test "Git staging never parses objects or executes inherited repository callbacks", %{
    tmp_dir: dir
  } do
    File.mkdir_p!(dir <> "/root/consumer")
    File.mkdir_p!(dir <> "/dep/.git/objects")
    File.mkdir_p!(dir <> "/dep/examples/deps")
    File.write!(dir <> "/dep/examples/deps/tracked.exs", "must survive")
    File.write!(dir <> "/dep/.git/HEAD", "this is not a Git object")
    File.write!(dir <> "/dep/.git/config", "[core]\nfsmonitor = touch #{dir}/executed\n")

    dep = %{
      "kind" => "git",
      "source" => dir <> "/dep",
      "destination" => "deps/example",
      "revision" => String.duplicate("a", 40),
      "url" => "https://example.invalid/\"quoted\""
    }

    req = Map.put(request(dir <> "/root"), "dependencies", [dep])
    assert {:ok, inventory} = Inputs.stage(req, dir <> "/stage")
    assert inventory["deps/example/examples/deps/tracked.exs"]["size"] == 12
    refute File.exists?(dir <> "/executed")
    config = File.read!(dir <> "/stage/deps/example/.git/config")
    refute config =~ "fsmonitor"
    assert config =~ "hooksPath = /dev/null"
    assert config =~ ~s(url = "https://example.invalid/\\\"quoted\\\"")
    assert File.read!(dir <> "/stage/deps/example/.git/HEAD") == "this is not a Git object"
  end

  @tag :tmp_dir
  test "source aliases are refused before budgeting traverses an unauthorized tree", %{
    tmp_dir: dir
  } do
    File.mkdir_p!(dir <> "/root/consumer")
    File.mkdir_p!(dir <> "/outside/tree")

    File.open!(dir <> "/outside/tree/large", [:write], fn file ->
      :file.position(file, 134_217_728)
      IO.binwrite(file, "x")
    end)

    File.ln_s!(dir <> "/outside", dir <> "/root/link")
    req = %{request(dir <> "/root") | "inputs" => ["link/tree"]}
    assert {:error, {:unsafe_input, _, :symlink}} = Inputs.stage(req, dir <> "/stage")
    refute File.exists?(dir <> "/stage")
  end

  @tag :tmp_dir
  test "accepted policy and proof references must name retained regular files", %{tmp_dir: dir} do
    File.mkdir_p!(dir <> "/root/consumer")
    File.write!(dir <> "/root/consumer/policy.json", "accepted bytes")
    req = Map.put(request(dir <> "/root"), "accepted_inputs", ["missing.json"])

    assert {:error, {:missing_referenced_input, "missing.json"}} =
             Inputs.stage(req, dir <> "/missing")

    assert {:error, :invalid_request} =
             Inputs.validate(%{req | "accepted_inputs" => ["../outside"]})

    assert {:error, {:missing_referenced_input, "missing.lean"}} =
             Inputs.stage(
               Map.put(req, "accepted_inputs", []) |> Map.put("proof_postlude", "missing.lean"),
               dir <> "/proof"
             )

    assert {:ok, inventory} =
             Inputs.stage(%{req | "accepted_inputs" => ["consumer/policy.json"]}, dir <> "/valid")

    assert inventory["consumer/policy.json"]["size"] == 14
  end

  @tag :tmp_dir
  test "input identity binds permission bits and empty directories", %{tmp_dir: dir} do
    File.mkdir_p!(dir <> "/consumer")
    File.write!(dir <> "/consumer/policy", "same bytes")
    File.chmod!(dir <> "/consumer/policy", 0o600)
    assert {:ok, first} = Inputs.stage(request(dir), dir <> "/stage-1")
    File.chmod!(dir <> "/consumer/policy", 0o644)
    assert {:ok, second} = Inputs.stage(request(dir), dir <> "/stage-2")
    refute first == second
    assert first["consumer/policy"]["mode"] == 0o600
    assert second["consumer/policy"]["mode"] == 0o644
    File.mkdir!(dir <> "/consumer/feature_enabled")
    assert {:ok, third} = Inputs.stage(request(dir), dir <> "/stage-3")
    refute second == third
    assert third["consumer/feature_enabled"]["type"] == "directory"
    req = Map.put(request(dir), "accepted_inputs", ["consumer/feature_enabled"])

    assert {:error, {:missing_referenced_input, "consumer/feature_enabled"}} =
             Inputs.stage(req, dir <> "/directory-reference")
  end

  @tag :tmp_dir
  test "closed schema, overlapping inputs/mounts and undeclared fields fail closed", %{
    tmp_dir: dir
  } do
    req = request(dir)
    assert {:error, :invalid_request} = Inputs.validate(Map.put(req, "token", "secret"))

    assert {:error, :invalid_request} =
             Inputs.validate(%{req | "environment" => %{"MIX_ENV" => "prod", "HOME" => "/root"}})

    assert {:error, :unsafe_mounts} =
             Inputs.validate(%{req | "writable_paths" => ["consumer/_build/nested/_build"]})

    assert {:error, :overlapping_inputs} =
             Inputs.validate(%{req | "inputs" => ["consumer", "consumer/config"]})

    assert {:error, :overlapping_inputs} =
             Inputs.validate(%{
               req
               | "dependencies" => [
                   %{"kind" => "path", "source" => dir, "destination" => "consumer/config"}
                 ]
             })

    assert {:error, :invalid_request} = Inputs.validate(%{req | "roots" => nil})
  end
end
