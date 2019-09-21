defmodule Perspective.ActionRequest.DefineEvent do
  def define(event_name, caller) do
    definition =
      quote do
        @derive Jason.Encoder

        defstruct id: "", actor_id: "", version: "", event_date: nil, data: %{}, meta: %{}
      end

    Module.create(event_name, definition, Macro.Env.location(caller))
  end
end
