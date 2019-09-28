defmodule Perspective.Dispatcher do
  def dispatch(request) do
    Perspective.Processor.run(request)
  end
end
