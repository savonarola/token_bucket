defmodule TokenBucket.Mixfile do
  use Mix.Project

  def project do
    [
      app: :token_bucket,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:excoveralls, "~> 0.8", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      name: :token_bucket,
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Ilya Averyanov"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/savonarola/token_bucket"},
      description: "Rate limiter implementing Token Bucket algorithm"
    ]
  end
end
