defmodule Perspective.ProjectionNames do
  def broadcaster(module) do
    append(module, ProjectionBroadcaster)
  end

  def controller(module) do
    append(module, ProjectionController)
  end

  def channel(module) do
    append(module, ProjectionChannel)
  end

  def endpoint(module) do
    append(module, PhoenixEndpoint)
  end

  def router(module) do
    append(module, ProjectionRouter)
  end

  def socket(module) do
    append(module, ProjectionSocket)
  end

  def supervisor(module) do
    append(module, Supervisor)
  end

  defp append(module, name) do
    Module.concat(module, name)
  end
end
