defmodule Core.ToDo.Reactor do
  use Perspective.Reactor

  initial_state do
    %Core.ToDo{}
  end

  update(%Core.ToDoAdded{data: data}, _state) do
    %Core.ToDo{}
    |> Map.put(:id, data.todo_id)
    |> Map.put(:name, data.name)
    |> Perspective.DomainPool.put()
  end

  update(%Core.ToDoCompleted{data: data}, _state) do
    Perspective.DomainPool.get!(data.todo_id)
    |> Map.put(:completed, true)
    |> Perspective.DomainPool.put()
  end

  update(%Core.ToDoRenamed{data: data}, _state) do
    Perspective.DomainPool.get!(data.todo_id)
    |> Map.put(:name, data.name)
    |> Perspective.DomainPool.put()
  end
end
