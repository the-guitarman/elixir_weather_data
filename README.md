[![Build Status](https://travis-ci.org/the-guitarman/club_homepage.svg?branch=master)](https://travis-ci.org/the-guitarman/club_homepage)
[![Code Climate](https://codeclimate.com/github/the-guitarman/club_homepage/badges/gpa.svg)](https://codeclimate.com/github/the-guitarman/club_homepage)
[![Built with Spacemacs](https://cdn.rawgit.com/syl20bnr/spacemacs/442d025779da2f62fc86c2082703697714db6514/assets/spacemacs-badge.svg)](http://github.com/syl20bnr/spacemacs)

# ElixirWeatherData

This application provides the current weather data for the given geo coordinates (latitude/longitude). It uses openweathermap.org v2.5 and holds the information within a gen server process. You may ask the process as often as you like. It asks the openweathermap api every hour once only.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `elixir_weather_data` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:elixir_weather_data, "~> 0.1.0"}]
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

## Usage

  ```elixir
  ElixirWeatherData.get
  # => {:ok,
  %{centigrade: 14.5, created_at: 1476096476, fahrenheit: 58.1,
   weather: "cloudy", wind_in_kilometers_per_hour: 10.0,
   wind_in_meters_per_second: 2.9}}
  ```
  
  In case of an error at the first openweathermap api request, you will get `{:error, <some error reason>}`, otherwise it will return the last received data. 
  
## License

Everything may break everytime. Therefore this package is licensed under the LGPL 3.0. Do whatever you want with it, but please give improvements and bugfixes back so everyone can benefit.
