defmodule Perspective.Reactor.MissingGenServer do
  defexception [:name]

  def exception(name) do
    %__MODULE__{
      name: name
    }
  end

  def message(%__MODULE__{name: name}) do
    "The genserver (#{name}) is not alive."
  end
end
