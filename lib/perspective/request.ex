defmodule Perspective.Request do
  def from(%{request: request, actor: actor} = data) do
    try do
      convert(data)
      |> Map.merge(%{request: request, actor: actor})
      |> Map.put(:date, DateTime.utc_now() |> DateTime.to_iso8601())
    rescue
      error in Perspective.Request.MissingAction -> {:error, error}
    end
  end

  defp convert(%{action: action_name, data: data} = request) do
    action = struct_from_action_name(action_name, data)

    struct(Perspective.ActionRequest, request)
    |> Map.put(:action, action)
  end

  defmodule MissingAction do
    defexception action_name: ""

    def exception(action_name) do
      %__MODULE__{
        action_name: action_name
      }
    end

    def message(%__MODULE__{action_name: action_name}) do
      "The action (#{action_name}) could not be found"
    end
  end

  defp struct_from_action_name(action_name, data) do
    try do
      struct_name = String.to_existing_atom("Elixir.#{action_name}")
      struct(struct_name, data)
    rescue
      _error in ArgumentError -> raise MissingAction, action_name
    end
  end
end

defmodule Perspective.ActionRequest do
  defstruct request: "", actor: "", date: "", action: %{}
end

defmodule Perspective.QueryRequest do
  defstruct request: "", actor: "", date: "", query: %{}
end
