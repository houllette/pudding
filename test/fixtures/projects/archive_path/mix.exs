defmodule ArchivePath.MixProject do
  use Mix.Project

  def project do
    [
      app: :archive_path,
      version: "0.1.0",
      elixir: "~> 1.20",
      deps: [{:pudding, path: "../../../.."}]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end
end
