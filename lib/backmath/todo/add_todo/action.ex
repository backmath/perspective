defmodule BackMath.AddToDo do
  defstruct [:name]

  def new(data) do
    struct(__MODULE__, data)
  end
end
