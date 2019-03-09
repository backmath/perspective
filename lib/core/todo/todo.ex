defmodule Core.ToDo do
  use Perspective.DomainNode

  defstruct id: "", name: "", completed: false

  def apply_event(_todo, %Core.ToDoAdded{} = event) do
    %Core.ToDo{}
    |> Map.put(:id, event.todo_id)
    |> Map.put(:name, event.name)
    |> case do
      new_todo -> {:ok, new_todo}
    end
  end

  def apply_event(todo, %Core.ToDoRenamed{} = event) do
    todo
    |> Map.put(:name, event.name)
    |> case do
      updated_todo -> {:ok, updated_todo}
    end
  end

  def apply_event(todo, %Core.ToDoCompleted{} = _event) do
    todo
    |> Map.put(:completed, true)
    |> case do
      completed_todo -> {:ok, completed_todo}
    end
  end
end
