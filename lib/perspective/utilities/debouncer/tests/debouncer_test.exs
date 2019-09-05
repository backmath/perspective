defmodule Perspective.Debouncer.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  defmodule Counter do
    use Perspective.GenServer

    initial_state do
      %{counter: 0}
    end

    def handle_call(:increment, _from, %{counter: counter}) do
      {:reply, :ok, %{counter: counter + 1}}
    end
  end

  defmodule DelayedIncrement do
    use Perspective.Debouncer

    execute do
      Process.sleep(10)

      Counter.call(:increment)
    end
  end

  setup(%{app_id: app_id}) do
    Counter.start_link(app_id: app_id)
    DelayedIncrement.start_link(app_id: app_id)

    :ok
  end

  test "delayed_increment calls only twice (because of the delay)" do
    DelayedIncrement.execute()
    DelayedIncrement.execute()
    DelayedIncrement.execute()

    Process.sleep(40)

    assert %{counter: 2} == Counter.call(:state)
  end

  test "delayed_increment calls thrice (because of the delay and resumation)" do
    DelayedIncrement.execute()
    DelayedIncrement.execute()
    Process.sleep(30)
    DelayedIncrement.execute()

    Process.sleep(20)

    assert %{counter: 3} == Counter.call(:state)
  end
end
