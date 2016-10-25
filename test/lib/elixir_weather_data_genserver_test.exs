defmodule ElixirWeatherDatai.GenServerTest do
  use ExUnit.Case, async: true
  doctest ElixirWeatherData.GenServer

  test "gen server state" do
    case ElixirWeatherData.GenServer.get do
      {:ok, data} ->
        assert data[:centigrade] == 14.5
        #assert data[:created_at] == 1475699097
        assert data[:fahrenheit] == 58.1
        assert data[:weather] == "cloudy"
        assert data[:humidity_in_percent] == 97
        assert data[:icon] == "04n"
        assert data[:icon_url] == "http://openweathermap.org/img/w/04n.png"
        assert data[:pressure_in_hectopascal] == 997
        assert data[:wind_in_kilometers_per_hour] == 10.0
        assert data[:wind_in_meters_per_second] == 2.9
        assert data[:wind_direction_in_degrees] == 246
      {:error, reason} -> assert reason == :page_not_found
    end
  end
end
