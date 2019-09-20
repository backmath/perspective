defmodule Perspective.Core.DomainPool.ProcessorSupervisor do
  use Supervisor

  def init(children \\ []) do
    Supervisor.init(children, strategy: :one_for_one)
  end

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end
end
