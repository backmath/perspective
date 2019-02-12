defmodule BackMath.ToDo do
  use Perspective.DomainNode

  defstruct id: "", name: "", completed: false

  def apply_event(_todo, %BackMath.ToDoAdded{} = event) do
    %BackMath.ToDo{}
    |> Map.put(:id, event.id)
    |> Map.put(:name, event.name)
    |> case do
      new_todo -> {:ok, new_todo}
    end
  end

  def apply_event(todo, %BackMath.ToDoRenamed{} = event) do
    todo
    |> Map.put(:name, event.name)
    |> case do
      updated_todo -> {:ok, updated_todo}
    end
  end

  def apply_event(todo, %BackMath.ToDoCompleted{} = _event) do
    todo
    |> Map.put(:completed, true)
    |> case do
      completed_todo -> {:ok, completed_todo}
    end
  end
end
