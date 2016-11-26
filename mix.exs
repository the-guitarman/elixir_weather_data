defmodule ElixirWeatherData.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_weather_data,
     version: "0.1.6",
     elixir: "~> 1.3",
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
      mod: { ElixirWeatherData, [] },
      #env: [initial_value: nil],
      registered: [:elixir_weather_data],
      applications: [:tzdata, :logger, :httpoison]
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
      {:poison, "~> 2.0"},
      {:httpoison, "~> 0.9.0"},
      {:timex, "~> 2.2.1"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
