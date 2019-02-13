defmodule Perspective.Notifications.Test do
  use ExUnit.Case

  defmodule ExampleEvent do
    defstruct [:id]
  end

  test "a process can subscribe to structs being emited" do
    Perspective.Notifications.subscribe(%ExampleEvent{})

    Perspective.Notifications.emit(%ExampleEvent{id: :hello})

    assert_receive %ExampleEvent{id: :hello}
  end
end
