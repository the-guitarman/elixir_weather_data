defmodule ElixirWeatherData.GenServer do
  use GenServer

  @valid_languages ["en", "de"]

  @doc """
  Starts the gen server.
  """
  def start_link(initial_value) do
    GenServer.start_link(__MODULE__, initial_value, name: __MODULE__)
  end

  @doc """
  Checks the given options.
  """
  def init(opts) do
    case check_opts(opts) do
      [] -> {:ok, get_data(opts)}
      error_reasons -> {:stop, error_reasons}
    end
  end

  def handle_call(:get, _from, {:error, parameters_map, _error_reason}) do
    create_reply(extract_request_parameters({:error, parameters_map}))
  end
  def handle_call(:get, _from, old_state = {:ok, _data}) do
    case cached_data_should_be_updated?(old_state) do
      true -> create_reply(old_state, extract_request_parameters(old_state))
      _    -> create_reply(old_state)
    end
  end

  defp create_reply({:ok, data}) do
    {:reply, {:ok, Map.delete(data, :parameters)}, {:ok, data}}
  end
  defp create_reply(parameters) do # when is_map{parameters} do
    case get_data(parameters) do
      {:ok, data} -> create_reply({:ok, data})
      {:error, parameters_map, error_reason} -> {:reply, {:error, error_reason}, {:error, parameters_map, error_reason}}
    end
  end
  defp create_reply(old_state, parameters) when is_map(parameters) do
    case get_data(parameters) do
      {:ok, data} -> create_reply({:ok, data})
      {:error, _parameters_map, _error_reason} -> create_reply(old_state)
    end
  end

  defp check_opts([api_key, language, coordinates]) do
    errors = check_api_key(api_key)
    errors = [check_language(language) | errors]
    errors = [check_coordinates(coordinates) | errors]
    List.flatten(errors)
  end

  defp check_api_key(api_key) when is_binary(api_key) do
    case String.match?(api_key, ~r/[a-z0-9]{32}/) do
      true -> []
      _ -> ["invalid api key given"]
    end
  end
  defp check_api_key(_api_key), do: ["no api key given"]

  defp check_language(language) when is_binary(language) do
    case Enum.member?(@valid_languages, language) do
      true -> []
      _ -> ["invalid language given"]
    end
  end
  defp check_language(_language), do: ["no language given"]

  defp check_coordinates(%{lat: lat, lon: lon}) when is_float(lat) and is_float(lon) do
    []
  end
  defp check_coordinates(_coordinates), do: ["no or invalid geo coordinates given"]




  @doc """
  Returns the current state:
  * `{:ok, weather_data_map}`
  * `{:error, error_reason_string}`
  """
  def get do
    GenServer.call __MODULE__, :get
  end




  defp get_module(:prod), do: ElixirWeatherData.OpenWeatherMapApi.HttpClient
  defp get_module(:dev), do: ElixirWeatherData.OpenWeatherMapApi.Sandbox
  defp get_module(:test), do: ElixirWeatherData.OpenWeatherMapApi.InMemory

  defp get_data(parameters = [api_key, language, coordinates]) do
    lat = round_value(coordinates.lat, 2)
    lon = round_value(coordinates.lon, 2)
    "http://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&lang=#{language}&appid=#{api_key}"
    |> get_module(Mix.env).send_request
    |> parse
    |> create_data_map
    |> add_request_parameters(parameters)
  end

  defp cached_data_should_be_updated?({:error, _reason}), do: true
  defp cached_data_should_be_updated?({:ok, data}) do
    one_hour_in_seconds = 60*60
    data[:created_at] < (timestamp_now - one_hour_in_seconds)
  end

  defp parse({:ok, body}), do: Poison.decode(body)
  defp parse({:error, reason}), do: {:error, reason}

  defp create_data_map({:error, reason}), do: {:error, reason}
  defp create_data_map({:ok, data}) do
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
  defp add_request_parameters({:error, error_reason}, parameters) do
    {:error, %{parameters: parameters}, error_reason}
  end

  defp extract_request_parameters({_, %{parameters: parameters}}) do
    parameters
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
