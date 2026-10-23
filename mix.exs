defmodule Pudding.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/houllette/pudding"

  def project do
    [
      app: :pudding,
      version: @version,
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      description:
        "Security verification for Elixir: discover security properties, find " <>
          "counterexamples, and generate independently checked proofs tied to the " <>
          "actual implementation.",
      package: package(),
      name: "Pudding",
      source_url: @source_url,
      docs: docs(),
      dialyzer: [
        plt_file: {:no_warn, "priv/plts/dialyzer.plt"},
        plt_add_apps: [:ex_unit, :mix]
      ],
      usage_rules: [file: "AGENTS.md", usage_rules: :all]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Tests need MIX_ENV=test; without this the alias runs in :dev.
  def cli do
    [preferred_envs: [precommit: :test]]
  end

  defp package do
    [
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url},
      # Explicit, because Hex's default includes priv/, where the Dialyzer PLT
      # lives. .gitignore doesn't apply to packages.
      files: ~w(lib .formatter.exs mix.exs README.md LICENSE)
    ]
  end

  defp docs do
    [
      main: "readme",
      extras: ["README.md"],
      source_ref: "v#{@version}"
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tidewave, "~> 0.8", only: :dev},
      {:bandit, "~> 1.0", only: :dev},
      {:reach, "~> 2.8", only: :test},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.40", only: [:dev, :test], runtime: false},
      {:usage_rules, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      # Bandit listens on all interfaces by default; Tidewave evaluates code, so
      # keep it on loopback like Phoenix's dev endpoint.
      tidewave:
        "run --no-halt -e 'Agent.start(fn -> Bandit.start_link(plug: Tidewave, port: 4000, ip: :loopback) end)'",
      precommit: [
        "deps.unlock --check-unused",
        # The audits read mix.lock only; they MUST precede compile, which
        # drops the Hex archive from the code path for the rest of the alias.
        "hex.audit",
        "deps.audit",
        "compile --warnings-as-errors",
        "format",
        "credo --strict",
        "usage_rules.sync --yes",
        "xref graph --label compile-connected --fail-above 0",
        "docs --warnings-as-errors",
        "test --warnings-as-errors"
      ]
    ]
  end
end
