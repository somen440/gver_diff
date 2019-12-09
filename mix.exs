defmodule GverDiff.Mixfile do
  use Mix.Project

  def project do
    [
      app: :gver_diff,
      version: "0.1.0",
      elixir: "~> 1.0",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      escript: [
        main_module: GverDiff.CLI,
        name: "gver_diff"
      ],
      deps: deps,
      package: package,
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.10", only: :test},
      {:dialyxir, "~> 0.4", only: [:test]},
      {:ex_doc, "~> 0.10", only: :dev}
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
