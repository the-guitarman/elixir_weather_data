defmodule ElixirWeatherData.GenServer do
  use GenServer

  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  def init(opts) do
    {:ok, get_data(opts)}
  end

  def handle_call(:get, _from, {:ok, value}) do
    {:ok, new_state} =
      case cached_data_should_be_updated?({:ok, value}) do
        true ->
          IO.inspect "1"
          get_data(extract_request_parameters({:ok, value}))
        _    ->
          IO.inspect "2"
          {:ok, value}
      end
    IO.inspect new_state
    {:reply, Map.delete(new_state, :parameters), {:ok, new_state}}
  end




  def get do
    GenServer.call __MODULE__, :get
  end




  # @api_key "cb3b951fc2b009115c9f5ac870360ba6"
  # @lang "de"
  # @city "Claussnitz"
  @open_weather_map_api Application.get_env(:elixir_weather_data, :open_weather_map_api)

  defp get_data(parameters = [api_key, language, coordinates]) do
    lat = round_value(coordinates.lat, 2)
    lon = round_value(coordinates.lon, 2)
    "http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&lang=#{language}&appid=#{api_key}"
    |> @open_weather_map_api.send_request
    |> parse
    |> create_data_map
    |> add_request_parameters(parameters)
  end

  defp cached_data_should_be_updated?({:error, _reason}), do: true
  defp cached_data_should_be_updated?({:ok, data}) do
    data[:created_at] < (timestamp_now - 5) #84600)
  end

  defp parse(nil), do: nil
  defp parse(body) do
    case Poison.decode(body) do
      {:ok, data} -> data
      {:error, reason} ->
        IO.inspect reason
        nil
    end
  end

  defp create_data_map(nil), do: {:error, :no_data_received}
  defp create_data_map(data) do
    centigrade =
      data["main"]["temp"]
      |> kelvin_to_centigrade()
      |> round_value(1)

    fahrenheit = centigrade_to_fahrenheit(centigrade)

    [%{"description" => description} | _tail] = data["weather"]

    wind_in_meters_per_second =
      data["wind"]["speed"]
      |> round_value(1)

    wind_in_kilometers_per_hour =
      meters_per_second_to_kilometers_per_hour(wind_in_meters_per_second)
      |> round_value

    {:ok, %{created_at: timestamp_now, centigrade: centigrade, fahrenheit: fahrenheit, weather: description, wind_in_kilometers_per_hour: wind_in_kilometers_per_hour, wind_in_meters_per_second: wind_in_meters_per_second}}
  end

  defp add_request_parameters({:ok, data}, parameters) do
    {:ok, Map.put(data, :parameters, parameters)}
  end

  defp extract_request_parameters({:ok, data}) do
    data[:parameters]
  end

  defp round_value(value, precision \\ 0)
  defp round_value(value, precision) when is_float(value) do
    Float.round(value, precision)
  end
  defp round_value(value, _precision), do: value

  defp kelvin_to_centigrade(value) do
    value - 273.15
  end

  defp centigrade_to_fahrenheit(value) do
    ((value * 9) / 5) + 32
  end

  defp meters_per_second_to_kilometers_per_hour(value) do
    value * 3.6 #0.868976242 #1.609
  end

  defp timestamp_now do
    Timex.DateTime.local
    |> Timex.to_unix()
  end
end
