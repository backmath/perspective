defmodule Perspective.DomainNode do
  @callback apply_event(struct, struct) :: {:ok, struct}

  defmodule EventApplier do
    def apply_event(%node_type{} = node, event) do
      node_type.apply_event(node, event)
    end
  end

  defmacro __using__(_) do
    quote do
      @behaviour Perspective.DomainNode

      def apply_event(node, event) do
        raise "The node (#{node.__struct__}) and event (#{event.__struct__}) provided do not have an associated matcher"
      end

      defoverridable apply_event: 2
    end
  end
end
