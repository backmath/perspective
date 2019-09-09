defmodule Core.ToDo.Reactor do
  use Perspective.Reactor

  update(%Core.ToDoAdded{data: data, actor_id: actor_id}, _state) do
    %Core.ToDo{}
    |> Map.put(:id, data.todo_id)
    |> Map.put(:name, data.name)
    |> Map.put(:creator_id, actor_id)
    |> Perspective.DomainPool.put!()
  end

  update(%Core.ToDoCompleted{data: data}, _state) do
    Perspective.DomainPool.get!(data.todo_id)
    |> Map.put(:completed, true)
    |> Perspective.DomainPool.put!()
  end

  update(%Core.ToDoRenamed{data: data}, _state) do
    Perspective.DomainPool.get!(data.todo_id)
    |> Map.put(:name, data.name)
    |> Perspective.DomainPool.put!()
  end
end
