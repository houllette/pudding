ExUnit.start(autorun: false)

if Mix.env() != :prod, do: raise("qualification requires MIX_ENV=prod")
Code.require_file("test/contract_test.exs", __DIR__)
Code.require_file("test/production_test.exs", __DIR__)

%{failures: failures} = ExUnit.run()
if failures != 0, do: System.halt(1)
