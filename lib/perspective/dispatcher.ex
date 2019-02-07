defmodule Perspective.Dispatcher do
  def dispatch(%{} = data) do
    # Generate Action
    {:ok, action} = Perspective.ActionGenerator.generate(data)

    case Perspective.Processor.run(action) do
      {:ok, action} -> {:ok, action}
    end
  end
end
