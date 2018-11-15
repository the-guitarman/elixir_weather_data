defmodule ElixirWeatherData.GenServerTest do
  use ExUnit.Case, async: false
  doctest ElixirWeatherData.GenServer

  test "gen server state" do
    assert Application.get_env(:elixir_weather_data, :api)

    case ElixirWeatherData.GenServer.get() do
      {:ok, data} ->
        assert data[:centigrade] == 14
        #assert data[:created_at] == 1475699097
        assert data[:fahrenheit] == 57
        assert data[:weather] == "cloudy"
        assert data[:humidity_in_percent] == 97
        assert data[:icon] == "04n"
        assert data[:icon_url] == "http://openweathermap.org/img/w/04n.png"
        assert data[:pressure_in_hectopascal] == 997
        assert data[:wind_in_kilometers_per_hour] == 11
        assert data[:wind_in_meters_per_second] == 3
        assert data[:wind_direction_in_degrees] == 246
        assert data[:wind_direction_abbreviation] == "WSW"
      {:error, reason} -> assert reason == :page_not_found
    end
  end
end
