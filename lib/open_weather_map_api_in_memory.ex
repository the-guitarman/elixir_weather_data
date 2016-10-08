defmodule ElixirWeatherData.OpenWeatherMapApi.InMemory do
  @behaviour ElixirWeatherData.OpenWeatherMapApi

  def send_request(_url) do
    {:ok, data} = Poison.encode(
      %{"base" => "stations", "clouds" => %{"all" => 76}, "cod" => 200, "coord" => %{"lat" => 50.93, "lon" => 12.88}, "dt" => 1474494204, "id" => 2939997, "main" => %{"grnd_level" => 997.48, "humidity" => 97, "pressure" => 997.48, "sea_level" => 1026.54, "temp" => 287.625, "temp_max" => 287.625, "temp_min" => 287.625}, "name" => "Claussnitz", "sys" => %{"country" => "DE", "message" => 0.0153, "sunrise" => 1474433699, "sunset" => 1474477575}, "weather" => [%{"description" => "cloudy", "icon" => "04n", "id" => 803, "main" => "Clouds"}], "wind" => %{"deg" => 246, "speed" => 2.91}}
    )
    Enum.random([
      {:ok, data},
      {:error, :page_not_found}
    ])
  end
end
