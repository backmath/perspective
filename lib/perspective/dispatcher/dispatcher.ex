defmodule Perspective.Dispatcher do
  def dispatch(request) do
    case Perspective.Processor.run(request) do
      {:ok, action} -> {:ok, action}
    end
  end
end
