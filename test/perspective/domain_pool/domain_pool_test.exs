defmodule Perspective.DomainPool.Test do
  use ExUnit.Case
  alias Perspective.DomainPool, as: Subject

  test "can be instantiated" do
    {:ok, pid} = Subject.start
    assert pid
  end

  test "can register pid" do
    {:ok, _pid} = Subject.start
    {:ok, _agent} = Agent.start(fn -> nil end)
    # Subject.register(pid, "123", agent)
  end
end
