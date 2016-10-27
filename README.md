[![Build Status](https://travis-ci.org/the-guitarman/elixir_weather_data.svg?branch=master)](https://travis-ci.org/the-guitarman/elixir_weather_data)
[![Code Climate](https://codeclimate.com/github/the-guitarman/elixir_weather_data/badges/gpa.svg)](https://codeclimate.com/github/the-guitarman/elixir_weather_data)
[![Built with Spacemacs](https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg)](http://github.com/syl20bnr/spacemacs)

# ElixirWeatherData

This application provides the current weather data for the given geo coordinates (latitude/longitude). It uses openweathermap.org v2.5 and holds the information within a gen server process. You may ask the process as often as you like. It asks the openweathermap api every hour once only.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `elixir_weather_data` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:elixir_weather_data, "~> 0.1.2"}]
    end
    ```

  2. Ensure `elixir_weather_data` is started before your application:

    ```elixir
    def application do
      [applications: [:elixir_weather_data]]
    end
    ```

  3. Provide your openweathermap api parameters:

  ```elixir
  config :elixir_weather_data, :api, 
    key: "<your openweathermap api key>",
    language: "<your openweathermap language: en, de or ...>",
    coordinates: [lat: 50.939583, lon: 12.886244]
  ```
  
  In the production environment the app will request the api of openweathermap.org to get the data. 
  
  In the development environment you may want to dicide to use sandbox data or send requests to the api of openweathermap.org. There are to modes available:
  - `:sandbox`
  - `:http_client`
  It defaults to `:sandbox`.
  
  ```elixir
  config :elixir_weather_data, :dev,
    mode: :sandbox
    
  # or
  
  config :elixir_weather_data, :dev,
    mode: :http_client
  ```

## Usage

  ```elixir
  ElixirWeatherData.get
  # => {:ok, %{
  #  centigrade: 14, 
  #  created_at: 1477595605, 
  #  fahrenheit: 57,
  #  humidity_in_percent: 97, 
  #  icon: "04n",
  #  icon_url: "http://openweathermap.org/img/w/04n.png",
  #  pressure_in_hectopascal: 997, 
  #  weather: "cloudy",
  #  wind_direction_abbreviation: "WSW", 
  #  wind_direction_in_degrees: 246,
  #  wind_in_kilometers_per_hour: 11, 
  #  wind_in_meters_per_second: 3
  # }}
  ```
  
  In case of an error at the first openweathermap api request, you will get `{:error, <some error reason>}`, otherwise it will return the last received data. 
  
## License

Everything may break everytime. Therefore this package is licensed under the LGPL 3.0. Do whatever you want with it, but please give improvements and bugfixes back so everyone can benefit.
