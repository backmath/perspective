defmodule Perspective.DomainPool.Application do
  use Application

  def start do
    children = [
      Perspective.DomainPool.Registry.child_spec()
      # {Perspective.DomainPool.ProcessorSupervisor, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def start(_, _), do: start()
end
