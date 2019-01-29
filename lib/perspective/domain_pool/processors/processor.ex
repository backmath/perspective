defmodule Perspective.DomainPool.Processor do
  use Agent
  alias Perspective.DomainPool.ProcessorSupervisor

  defmodule State, do: defstruct identifiers: [], queue: [], started_at: DateTime.utc_now()
  defmodule Action, do: defstruct data: %{}

  ## API

  def state(processor) do
    Agent.get(processor, fn state -> state end)
  end

  def add_to_queue(processor, something) do
    processor
    |> Agent.update(fn %State{queue: queue} = old ->
      Map.put(old, :queue, queue ++ [something])
    end)
  end


  ## BOOT

  def start_link(%State{} = state) do
    Agent.start_link(fn -> state end)
  end

  def start_link do
    Agent.start_link(fn -> %State{} end)
  end


  # def checkout(identifiers) do
  #   pid = Agent.start(fn -> identifiers end)
  #   # ProcessorSupervisor.start_child(pid)
  #   # processor = start_link([id: id, data: data])
  #   # case checkout(identifiers) do
  #   # end
  # end

  # # def run(event) do
  # #   # event
  # #   # authorize
  # #   # validate
  # #   # transform
  # # end
end
