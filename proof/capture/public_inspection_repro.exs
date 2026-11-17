# Public APIs only. Run after `mix compile`:
# elixir -pa _build/dev/lib/lynx/ebin proof/capture/public_inspection_repro.exs
Code.compiler_options(debug_info: true)

[{PlainInspectionTarget, beam}] =
  Code.compile_string("""
  defmodule PlainInspectionTarget do
    def identity(value), do: value
  end
  """)

IO.puts(
  "Elixir #{System.version()}, OTP #{System.otp_release()}, ERTS #{:erlang.system_info(:version)}"
)

# This failure is correct for Laws.verify/2, not a failed proof or translator bug.
# The feature request is a separate, proof-free MFA inspection entry point.
try do
  Lynx.Laws.verify([beam], cache: false)
  raise "unexpected: verification accepted a module without laws"
rescue
  error in CompileError ->
    unless Exception.message(error) =~ "no laws", do: reraise(error, __STACKTRACE__)
    IO.puts("EXPECTED PUBLIC API BOUNDARY: " <> Exception.message(error))
end
