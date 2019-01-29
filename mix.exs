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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
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
