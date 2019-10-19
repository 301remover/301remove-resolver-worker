defmodule ResolverWorker.MixProject do
  use Mix.Project

  def project do
    [
      app: :resolver_worker,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ResolverWorker.Application, []}
    ]
  end

  defp deps do
    [
      {:freddy, "~> 0.15.0"}
    ]
  end
end
