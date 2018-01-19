defmodule ElixirWeatherData.OpenWeatherMapApi.HttpClient do
  @behaviour ElixirWeatherData.OpenWeatherMapApi

  def send_request(url) do
    request_api(url)
  end

  defp request_api(url) do
    try do
      # case HTTPoison.get(url, [], [timeout: 500, recv_timeout: 500]) do
      #   {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      #   {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, :page_not_found}
      #   {:ok, %HTTPoison.Response{status_code: _}} -> {:error, :unknown_error}
      #   {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      #   _ -> {:error, :unknown_error}
      # end

      # IO.inspect "HTTPoison.get!('#{url}', [], [timeout: 500, recv_timeout: 500])"

      case HTTPoison.get!(url, [], [timeout: 500, recv_timeout: 500]) do
        %HTTPoison.Response{status_code: 200, body: body} -> {:ok, body}
        %HTTPoison.Response{status_code: 404} -> {:error, :page_not_found}
        %HTTPoison.Response{status_code: _} -> {:error, :unknown_error}
        %HTTPoison.Error{reason: reason} -> {:error, reason}
        _ -> {:error, :unknown_error}
      end
    catch
      _ -> {:error, :timeout}
    rescue
      _ -> {:error, :timeout}
    end
  end
end
