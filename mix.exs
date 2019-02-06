defmodule Perspective.MixProject do
  use Mix.Project

  def project do
    [
      app: :perspective,
      name: "perspective",
      version: "0.0.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/backmath/perspective",
      description: description(),
      package: package(),
      deps: deps(),
      consolidate_protocols: Mix.env() != :test
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Perspective.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"}
    ]
  end

  defp description do
    "An event sourcing library based upon asynchronously generated perspectives"
  end

  defp package do
    [
      maintainers: ["Josh Freeman"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/backmath/perspective"},
      files: ~w(lib CHANGELOG.md LICENSE.md mix.exs README.md .formatter.exs)
    ]
  end
end
