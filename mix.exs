defmodule ElixirWeatherData.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_weather_data,
     version: "0.2.5",
     elixir: "~> 1.7",
     description: "This application provides the current weather data for the given geo coordinates (latitude/longitude) based on openweathermap.org v2.5.",
     docs: [extras: ["README.md"]],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      application: [:tzdata, :httpoison],
      extra_applications: [:logger],
      mod: {ElixirWeatherData, []}
    ]
  end

  def package do
    [
      name: :elixir_weather_data,
      files: ["lib", "mix.exs"],
      maintainers: ["guitarman78"],
      licenses: ["LGPL 3.0"],
      links: %{"Github" => "https://github.com/the-guitarman/elixir_weather_data"}
    ]
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
  defp deps do
    [
      {:poison, "~> 2.2 or ~> 3.1", optional: true},
      {:httpoison, "~> 0.11"},
      {:timex, "~> 3.3"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end
end
