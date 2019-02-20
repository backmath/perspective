defmodule Perspective.ProjectionRegistry do
  defmacro __using__(_) do
    quote do
      import Perspective.ProjectionRegistry
      import Perspective.ModuleRegistry
      register_module(Perspective.ProjectionRegistry)
      @projections []
    end
  end

  defmacro register_projection(projection) do
    quote do
      @projections [unquote(projection).projection | @projections]
      def projections, do: @projections
    end
  end

  def projections do
    Perspective.ModuleRegistry.list(Perspective.ProjectionRegistry)
    |> Enum.map(fn projection -> projection.projection_spec end)
  end
end
