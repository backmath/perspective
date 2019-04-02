defmodule Perspective.Dispatcher.Test do
  use ExUnit.Case

  test "begin process of dispatching JSON / struct data to action to correct processor" do
    assert {:ok, something} = Perspective.Dispatcher.dispatch(example_request())
  end

  def example_request do
    Core.AddToDo.new(%{
      name: "Demonstrate how to generate an action from a data struct"
    })
  end
end
