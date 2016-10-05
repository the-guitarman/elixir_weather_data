defmodule ElixirWeatherData.OpenWeatherMapApi.HttpClient do
  def send_request(url) do
    request_api(url)
  end

  defp request_api(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :page_not_found}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
    end
  end
end
