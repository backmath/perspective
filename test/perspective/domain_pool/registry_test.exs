defmodule Perspective.DomainPool.Registry.Test do
  use ExUnit.Case
  alias Perspective.DomainPool.Registry, as: Subject
  import ExUnit.CaptureLog

  setup_all do
    {:ok, _registry} = Subject.start_link()
    :ok
  end

  test "can be started idempotently, logs if already started" do
    # Registry already started in setup_all

    assert capture_log(fn ->
      Subject.start_link()
    end) =~ "The registry Elixir.Perspective.DomainPool.Registry has already been started"
  end

  test "can register pid" do
    name = {:via, Registry, {Subject, "123-abc"}}

    {:ok, pid} = Agent.start_link(fn -> %{abc: 123} end, name: name)

    [{found_pid, _data}] = Registry.lookup(Subject, "123-abc")

    assert pid === found_pid
  end
end
