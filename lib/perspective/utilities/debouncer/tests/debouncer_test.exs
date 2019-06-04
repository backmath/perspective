defmodule Perspective.Debouncer.Test do
  use ExUnit.Case

  @name TestDebouncer

  setup_all do
    case Perspective.Debouncer.start_link(name: @name) do
      {:ok, _pid} -> :ok
    end
  end

  setup do
    {:ok, agent} = Agent.start_link(fn -> %{call_count: 0} end)

    Perspective.Debouncer.register(@name, :delayed_increment, fn ->
      Process.sleep(10)

      Agent.update(agent, fn %{call_count: count} ->
        %{
          call_count: count + 1
        }
      end)
    end)

    {:ok, %{agent: agent}}
  end

  test "delayed_increment calls only twice (because of the delay)", %{agent: agent} do
    assert 0 == Agent.get(agent, fn %{call_count: count} -> count end)

    Perspective.Debouncer.execute(@name, :delayed_increment)
    Perspective.Debouncer.execute(@name, :delayed_increment)
    Perspective.Debouncer.execute(@name, :delayed_increment)

    Process.sleep(40)

    assert 2 == Agent.get(agent, fn %{call_count: count} -> count end)
  end

  test "delayed_increment calls thrice (because of the delay and resumation)", %{agent: agent} do
    assert 0 == Agent.get(agent, fn %{call_count: count} -> count end)

    Perspective.Debouncer.execute(@name, :delayed_increment)
    Perspective.Debouncer.execute(@name, :delayed_increment)
    Process.sleep(30)
    Perspective.Debouncer.execute(@name, :delayed_increment)

    Process.sleep(20)

    assert 3 == Agent.get(agent, fn %{call_count: count} -> count end)
  end

  test "calling execute/register on an undefined " do
    assert_raise Perspective.Debouncer.MissingDebouncer, fn ->
      Perspective.Debouncer.execute(Missing, :empty)
    end

    assert_raise Perspective.Debouncer.MissingDebouncer, fn ->
      Perspective.Debouncer.register(Missing, :empty, fn -> nil end)
    end
  end
end
