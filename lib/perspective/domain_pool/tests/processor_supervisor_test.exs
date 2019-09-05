defmodule Perspective.DomainPool.ProcessorSupervisor.Test do
  use ExUnit.Case, async: true
  alias Perspective.DomainPool.ProcessorSupervisor, as: Subject

  setup_all do
    {:ok, _pid} = Perspective.DomainPool.ProcessorSupervisor.start_link([])
    :ok
  end

  test "no tests yet" do
    assert nil != Subject
  end
end
