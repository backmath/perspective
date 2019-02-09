defmodule Perspective.DomainPoolSubscriber.Test do
  use ExUnit.Case

  test "Emitting data to a topic will notify the subscribing process" do
    {:ok, pid} = Perspective.DomainPoolSubscriber.start_link("abc:123")

    assert_process_receive(pid, %{event: :data}, fn ->
      Perspective.DomainPoolNotifications.emit("abc:123", %{event: :data})
    end)
  end

  defp assert_process_receive(process, message, function) do
    :erlang.trace(process, true, [:receive])

    function.()

    assert_receive {:trace, ^process, :receive, ^message}
  end
end
