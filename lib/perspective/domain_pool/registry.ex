defmodule Perspective.DomainPool.Registry do
  alias Registry, as: ExRegistry
  require Logger

  def start_link([keys: keys, name: name]) do
    case ExRegistry.start_link(keys: keys, name: name) do
      {:ok, pid} -> {:ok, pid}
      {:error, {:already_started, pid}} -> already_started(pid)
    end
  end

  def already_started(pid) do
    Logger.info("The registry #{__MODULE__} has already been started")
    {:ok, pid}
  end

  def start_link do
    [init_values | _tail] = child_spec()
      |> Map.fetch!(:start)
      |> elem(2)

    start_link(init_values)
  end

  def child_spec do
    %{
      id: __MODULE__,
      start: { __MODULE__, :start_link, [[keys: :unique, name: __MODULE__]] }
    }
  end
end
