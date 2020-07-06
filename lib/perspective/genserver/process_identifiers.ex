defmodule Perspective.GenServer.ProcessIdentifiers do
  def store(module, opts) do
    Perspective.AppIDLookup.fetch_and_set()
    Process.put(:uri, module.uri(opts))
    Process.put(:name, module.name(opts))
    Process.put(:module, module)
  end
end
