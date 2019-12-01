defmodule GverDiff.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gver_diff,
      version: "0.0.1",
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      escript: [
        main_module: GverDiff.CLI,
        name: "bin/gver_diff",
      ],
      deps: deps,
      package: package,
      test_coverage: [tool: ExCoveralls],
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.10", only: :test},
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["somen440"],
      licenses: ["MIT"],
      description: "Guarantees that version differences are as defined.",
      links: %{"GitHub" => "https://github.com/somen440/gver_diff"}
    ]
  end
end