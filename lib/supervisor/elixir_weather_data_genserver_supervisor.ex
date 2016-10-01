defmodule ElixirWeatherData.GenServer.Supervisor do
  use Supervisor

  def start_link(initial_value) do
    Supervisor.start_link(__MODULE__, [initial_value], name: __MODULE__)
  end

  def init(opts) do
    children = [
      worker(ElixirWeatherData.GenServer, opts, restart: :permanent)
    ]
    supervise children, strategy: :one_for_one
  end
end
