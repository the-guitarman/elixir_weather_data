defmodule ElixirWeatherData.OpenWeatherMapApi.HttpClient do
  def send_request(url) do
    request_api(url)
  end

  defp request_api(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> body
      {:ok, %HTTPoison.Response{status_code: 404}} -> nil
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
        nil
    end
  end
end
