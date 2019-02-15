defmodule Perspective.ModuleRegistry.Test.Some.Namespace do
end

defmodule Perspective.ModuleRegistry.Test.Example do
  use Perspective.ModuleRegistry
  register_module(Perspective.ModuleRegistry.Test.Some.Namespace)
end
