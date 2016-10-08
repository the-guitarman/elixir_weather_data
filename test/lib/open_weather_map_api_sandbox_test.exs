defmodule ElixirWeatherData.OpenWeatherMapApi.SandboxTest do
  use ExUnit.Case, async: true
  doctest ElixirWeatherData.GenServer

  test "sandbox test data" do
    {:ok, encoded_data} = ElixirWeatherData.OpenWeatherMapApi.Sandbox.send_request("url")
    assert encoded_data == "{\"wind\":{\"speed\":2.91,\"deg\":246},\"weather\":[{\"main\":\"Clouds\",\"id\":803,\"icon\":\"04n\",\"description\":\"cloudy\"}],\"sys\":{\"sunset\":1474477575,\"sunrise\":1474433699,\"message\":0.0153,\"country\":\"DE\"},\"name\":\"Claussnitz\",\"main\":{\"temp_min\":287.625,\"temp_max\":287.625,\"temp\":287.625,\"sea_level\":1026.54,\"pressure\":997.48,\"humidity\":97,\"grnd_level\":997.48},\"id\":2939997,\"dt\":1474494204,\"coord\":{\"lon\":12.88,\"lat\":50.93},\"cod\":200,\"clouds\":{\"all\":76},\"base\":\"stations\"}"
  end
end
