defmodule Perspective.Index.Test do
  use ExUnit.Case
  use Perspective.BootAppPerTest

  defmodule SomeEvent do
    defstruct [:some_id, :data]
  end

  defmodule AddEvent do
    defstruct [:some_id, :number]
  end

  defmodule Example do
    use Perspective.Index

    index_key(%{some_id: some_id}) do
      some_id
    end

    initial_value do
      0
    end

    index(%SomeEvent{data: data}, _state) do
      data
    end

    index(%AddEvent{number: number}, state) do
      state + number
    end
  end

  test "using an index", context do
    Example.start_link(context)

    assert %{} == Example.data()

    Perspective.Notifications.emit(%SomeEvent{some_id: "abc-123", data: true})
    Perspective.Notifications.emit(%SomeEvent{some_id: "abc-456", data: false})
    Perspective.Notifications.emit(%SomeEvent{some_id: "abc-789", data: nil})
    Perspective.Notifications.emit(%AddEvent{some_id: "num-123", number: 3})
    Perspective.Notifications.emit(%AddEvent{some_id: "num-123", number: 4})

    assert true == Example.find("abc-123")
    assert false == Example.find("abc-456")
    assert nil == Example.find("abc-789")
    assert 7 == Example.find("num-123")
    assert nil == Example.find("missing")
  end
end
