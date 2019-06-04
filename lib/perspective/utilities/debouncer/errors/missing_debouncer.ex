defmodule Perspective.Debouncer.MissingDebouncer do
  defexception [:name]

  def exception(name) do
    %__MODULE__{
      name: name
    }
  end

  def message(%__MODULE__{name: name}) do
    "The debouncer (#{name}) is not alive. If this is a Reactor, ensure that you are supervising the [Name].Supervisor. If you are using this directly, ensure this is supervised and launched"
  end
end
