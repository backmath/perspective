defmodule Perspective.Core.ToDos do
  use Perspective.Index

  initial_value do
    %Perspective.Core.ToDo{}
  end

  index_key(%{data: %{todo_id: todo_id}}) do
    todo_id
  end

  index(%Perspective.Core.ToDoAdded{data: data, actor_id: actor_id}, todo) do
    todo
    |> Map.put(:id, data.todo_id)
    |> Map.put(:name, data.name)
    |> Map.put(:creator_id, actor_id)
  end

  index(%Perspective.Core.ToDoCompleted{}, todo) do
    Map.put(todo, :completed, true)
  end

  index(%Perspective.Core.ToDoRenamed{data: data}, todo) do
    Map.put(todo, :name, data.name)
  end
end
