defmodule Perspective.Core.ToDo.Reactor do
  use Perspective.Reactor

  update(%Perspective.Core.ToDoAdded{data: data, actor_id: actor_id}, _state) do
    %Perspective.Core.ToDo{}
    |> Map.put(:id, data.todo_id)
    |> Map.put(:name, data.name)
    |> Map.put(:creator_id, actor_id)
    |> Perspective.Core.DomainPool.put!()
  end

  update(%Perspective.Core.ToDoCompleted{data: data}, _state) do
    Perspective.Core.DomainPool.get!(data.todo_id)
    |> Map.put(:completed, true)
    |> Perspective.Core.DomainPool.put!()
  end

  update(%Perspective.Core.ToDoRenamed{data: data}, _state) do
    Perspective.Core.DomainPool.get!(data.todo_id)
    |> Map.put(:name, data.name)
    |> Perspective.Core.DomainPool.put!()
  end
end
