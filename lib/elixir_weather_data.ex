defmodule ElixirWeatherData do
  use Application

  def start(_type, args) do
    ElixirWeatherData.GenServer.Supervisor.start_link(args, name: ElixirWeatherData.GenServer.Supervisor)
  end

  def get do
    ElixirWeatherData.GenServer.get()
  end

  def env() do
    Application.get_env(:elixir_weather_data, :environment, nil)
  end
end
