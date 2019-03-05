defmodule Perspective.MixProject do
  use Mix.Project

  def project do
    [
      app: :perspective,
      name: "perspective",
      version: "0.0.1",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/backmath/perspective",
      description: description(),
      package: package(),
      deps: deps(),
      consolidate_protocols: Mix.env() != :test,
      compilers: [:phoenix] ++ Mix.compilers(),
      test_paths: ["lib/", "test/"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [
        :logger,
        :phoenix,
        :phoenix_pubsub
      ],
      mod: {Perspective.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:distillery, "~> 2.0"},
      {:jason, "~> 1.1"},
      {:phoenix_live_reload, "~> 1.2"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix, "~> 1.4.0"},
      {:plug_cowboy, "~> 2.0"},
      {:uuid, "~> 1.1"},
      {:vex, "~> 0.7.0"}
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
