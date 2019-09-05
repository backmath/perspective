defmodule Perspective.Reactor.BackupStateMissing do
  defexception [:name]

  def exception(name) do
    %__MODULE__{
      name: name
    }
  end

  def message(%__MODULE__{name: name}) do
    "The backup state for the  #{name} reactor could not be found."
  end
end
