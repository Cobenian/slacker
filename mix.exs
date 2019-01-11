defmodule Slacker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :slacker,
      version: "0.1.15",
      elixir: "~> 1.7",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp description() do
    "Send messages to Slack"
  end

  defp package() do
    [
      organization: "cobenian",
      # These are the default files included in the package
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Bryan Weber", "Adam Guyot"],
      licenses: ["proprietary"],
      links: %{"GitHub" => "https://github.com/cobenian/slacker"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application() do
    [mod: {Slacker, []}, extra_applications: [:logger, :ssl]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps() do
    [
      {:httpoison, "~> 1.0"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false},
      {:jason, "~> 1.1"}
    ]
  end
end
