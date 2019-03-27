defmodule Perspective.DomainEventTransformers do
  def from_map(%{} = data) do
    extract_event_struct_type(data)
    |> to_domain_event(data)
  end

  def to_map(event) do
    Map.from_struct(event)
    |> Map.put(:event_type, struct_name_to_string(event.__struct__))
    |> Map.put(:data, Map.from_struct(event.data))
  end

  defp to_domain_event(struct_type, data) do
    struct(struct_type, %{
      id: data.id,
      actor_id: data.actor_id,
      event_date: DateTime.from_iso8601(data.event_date) |> elem(1),
      data: struct(Module.concat(struct_type, Data), data.data),
      meta: %{
        request_date: DateTime.from_iso8601(data.meta.request_date) |> elem(1)
      }
    })
  end

  defp extract_event_struct_type(data) do
    String.replace(data.event_type, ~r/^/, "Elixir.")
    |> String.to_existing_atom()
  end

  defp struct_name_to_string(atom) do
    to_string(atom)
    |> String.replace(~r/^Elixir./, "")
  end
end
