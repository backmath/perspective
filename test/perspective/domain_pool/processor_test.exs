defmodule Perspective.DomainPool.Processor.Test do
  use ExUnit.Case
  alias Perspective.DomainPool.Processor, as: Subject

  test "a processor will yield it's state" do
    {:ok, processor} = Subject.start_link

    assert %Subject.State{} == Subject.state(processor)
  end

  test "a processor can add pids to the queue" do
    {:ok, processor} = Subject.start_link

    pid = spawn(fn -> nil end)
    :ok = Subject.add_to_queue(processor, pid)

    assert %Subject.State{
      queue: [pid]
    } == Subject.state(processor)
  end

  test "a processor with an empty queue dies after 1 second" do

  end
end
