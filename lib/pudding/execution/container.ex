defmodule Pudding.Execution.Container do
  @moduledoc """
  Bounded Linux container execution, never an unsandboxed subprocess fallback.

  The container engine and enclosing VM are trusted. Each invocation has a name
  fixed by trusted preparation; timeout/output overflow forcibly removes that
  container, including descendants. CLI output is bounded independently of guest
  storage. No host environment is forwarded into the guest.
  """

  @doc "Runs an engine command with bounded output and wall time, killing its container on failure."
  @spec command(arguments :: [String.t()], options :: keyword()) ::
          {:ok, binary()} | {:error, map()}
  def command(arguments, options \\ []) do
    executable = Keyword.get(options, :engine, "docker") |> System.find_executable()

    if executable do
      bounded(executable, arguments, options)
    else
      {:error, %{reason: :engine_unavailable, output: ""}}
    end
  end

  defp bounded(executable, arguments, options) do
    limit = Keyword.get(options, :output_bytes, 1_048_576)
    deadline = System.monotonic_time(:millisecond) + Keyword.get(options, :timeout_ms, 30_000)

    port =
      Port.open({:spawn_executable, executable}, [
        :binary,
        :exit_status,
        :stderr_to_stdout,
        env: Keyword.get(options, :env, []),
        args: arguments
      ])

    result = collect(port, deadline, limit, [], 0)

    case result do
      {:ok, _} ->
        result

      {:error, _} ->
        if name = options[:container] do
          bounded(executable, ["rm", "--force", name], timeout_ms: 30_000)
        end

        result
    end
  end

  defp collect(port, deadline, limit, chunks, size) do
    remaining = max(deadline - System.monotonic_time(:millisecond), 0)

    receive do
      {^port, {:data, bytes}} ->
        if size + byte_size(bytes) > limit do
          close(port)
          {:error, %{reason: :output_limit, output: IO.iodata_to_binary(Enum.reverse(chunks))}}
        else
          collect(port, deadline, limit, [bytes | chunks], size + byte_size(bytes))
        end

      {^port, {:exit_status, 0}} ->
        {:ok, IO.iodata_to_binary(Enum.reverse(chunks))}

      {^port, {:exit_status, status}} ->
        {:error,
         %{
           reason: :nonzero_exit,
           status: status,
           output: IO.iodata_to_binary(Enum.reverse(chunks))
         }}
    after
      remaining ->
        close(port)
        {:error, %{reason: :timeout, output: IO.iodata_to_binary(Enum.reverse(chunks))}}
    end
  end

  defp close(port) do
    if Port.info(port), do: Port.close(port)
  end

  @doc "Returns enforced outer options; callers supply only trusted mounts and fixed commands."
  @spec isolation(name :: String.t(), limits :: map()) :: [String.t()]
  def isolation(name, limits) do
    [
      "run",
      "--name",
      name,
      "--network",
      "none",
      "--read-only",
      "--cap-drop",
      "ALL",
      "--security-opt",
      "no-new-privileges",
      "--security-opt",
      "seccomp=unconfined",
      "--security-opt",
      "label=disable",
      "--security-opt",
      "unmask=ALL",
      "--pids-limit",
      to_string(limits["pids"]),
      "--memory",
      limits["memory"],
      "--memory-swap",
      limits["memory"],
      "--cpus",
      "4",
      "--ulimit",
      "nofile=1024:1024",
      "--ulimit",
      "core=0:0",
      "--log-driver",
      "none",
      "--tmpfs",
      "/tmp:rw,exec,nosuid,nodev,size=512m,mode=1777",
      "--tmpfs",
      "/scratch:rw,exec,nosuid,nodev,size=2g,mode=1777"
    ]
  end

  @doc "Returns the supported default bounds, also retained in each capture manifest."
  @spec limits() :: map()
  def limits do
    %{
      "wall_ms" => 1_200_000,
      "output_bytes" => 2_097_152,
      "artifact_bytes" => 134_217_728,
      "memory" => "6g",
      "pids" => 256,
      "workspace" => "4g"
    }
  end
end
