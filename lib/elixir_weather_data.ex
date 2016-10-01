defmodule ElixirWeatherData do
  use Application

  def start(_type, args) do
    ElixirWeatherData.GenServer.Supervisor.start_link(
      #Application.get_env(:elixir_weather_data, :initial_value)
      args
    )
  end
end
