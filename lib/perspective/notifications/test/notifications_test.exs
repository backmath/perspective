defmodule Perspective.Notifications.Test do
  use ExUnit.Case, async: true
  use Perspective.BootAppPerTest

  defmodule ExampleEvent do
    defstruct [:id]
  end

  test "a process can subscribe to structs being emitted" do
    Perspective.Notifications.subscribe(%ExampleEvent{})

    Perspective.Notifications.emit(%ExampleEvent{id: :hello})

    assert_receive %ExampleEvent{id: :hello}
  end

  test "a process can subscribe to structs and ids being emitted" do
    Perspective.Notifications.subscribe(%ExampleEvent{}, "todo:abc-123")

    Perspective.Notifications.emit(%ExampleEvent{id: :hello}, "todo:abc-123")

    assert_receive %ExampleEvent{id: :hello}
  end
end
