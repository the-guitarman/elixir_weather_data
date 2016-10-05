defmodule ElixirWeatherData.OpenWeatherMapApi do
  @doc ""
  @callback send_request(url :: String.t) :: {:ok, Map.t}
  @doc ""
  @callback send_request(url :: String.t) :: {:error, Nil}
end
