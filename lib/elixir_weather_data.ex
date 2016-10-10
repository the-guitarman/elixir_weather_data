defmodule ElixirWeatherData do
  use Application

  def start(_type, args) do
    ElixirWeatherData.GenServer.Supervisor.start_link(args)
  end

  def get do
    ElixirWeatherData.GenServer.get
  end
end
