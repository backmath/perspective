defmodule Perspective.ActionGenerator do
  def generate(%{} = data) do
    action =
      %BackMath.AddToDo{
        actor: data.actor,
        request: data.request,
        request_date: data.request_date,
        references: data.references
      }
      |> Map.merge(data.data)

    case Vex.validate(action) do
      {:ok, action} -> {:ok, action}
      {:error, errors} -> {:error, %Perspective.Action.InvalidAction{action: action, errors: errors}}
    end
  end
end
