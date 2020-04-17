defmodule Perspective.GenServer.Test do
  use ExUnit.Case, async: true

  defmodule Example do
    use Perspective.GenServer

    def handle_call(:hello, _from, state) do
      {:reply, :hi!, state}
    end
  end

  test "starting a genserver without a an app_id can be found" do
    Process.put(:app_id, "")
    {:ok, expected_pid} = Example.start_link(:ok)

    actual_pid = GenServer.whereis({:global, "Perspective.GenServer.Test.Example"})

    assert expected_pid == actual_pid
  end

  test "starting a genserver with an options list containing app_id can be found" do
    Process.put(:app_id, "com.perspectivelib")
    {:ok, expected_pid} = Example.start_link(app_id: "com.perspectivelib")

    actual_pid = GenServer.whereis({:global, "com.perspectivelib.Perspective.GenServer.Test.Example"})

    assert expected_pid == actual_pid
  end

  test "starting a genserver with options map containing app_id can be found" do
    Process.put(:app_id, "com.perspectivelib")
    {:ok, expected_pid} = Example.start_link(%{app_id: "com.perspectivelib"})

    actual_pid = GenServer.whereis({:global, "com.perspectivelib.Perspective.GenServer.Test.Example"})

    assert expected_pid == actual_pid
  end

  test "call a genserver by its registered name" do
    Process.put(:app_id, "com.perspectivelib")
    Example.start_link(app_id: "com.perspectivelib")

    name = Perspective.GenServer.Names.name(Example, "com.perspectivelib")

    assert :hi! == GenServer.call(name, :hello)
  end

  test "a genserver's initial state is nil when undefined" do
    Process.put(:app_id, "com.perspectivelib")

    Example.start_link(app_id: "com.perspectivelib")

    name = Perspective.GenServer.Names.name(Example, "com.perspectivelib")

    assert nil == GenServer.call(name, :state)
  end

  defmodule InitialStateExample do
    use Perspective.GenServer

    initial_state do
      :data
    end
  end

  test "a genserver can self-report it's app_id and name" do
    Process.put(:app_id, "com.perspectivelib.123")

    InitialStateExample.start_link(app_id: "com.perspectivelib.123")
    Process.put(:app_id, "com.perspectivelib.123")

    result = InitialStateExample.call(:app_id)
    assert result == "com.perspectivelib.123"

    name = Perspective.GenServer.Names.name(InitialStateExample, "com.perspectivelib.123")
    result = InitialStateExample.call(:name)
    assert result == name
  end

  test "a genserver's initial state the result of initial_state(block)" do
    Process.put(:app_id, "com.perspectivelib")

    InitialStateExample.start_link(app_id: "com.perspectivelib")
    Process.put(:app_id, "com.perspectivelib")

    assert :data == InitialStateExample.call(:state)
  end

  test "use Perspective.GenServer.start_link without configuration gives a helpful error" do
    Process.delete(:app_id)

    assert_raise(ArgumentError, fn ->
      InitialStateExample.start_link(app_id: "com.perspectivelib.123")
    end)
  end
end
