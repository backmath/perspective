defmodule Perspective.EventChainSupervisor do
  use Perspective.Supervisor

  children do
    [
      Perspective.EventChain.PageManifest,
      Perspective.EventChain.CurrentPage,
      Perspective.EventChain.PageBuffer,
      Perspective.EventChain.PageWriter,
      Perspective.EventChain.PageWriter.Debouncer,
    ]
  end
end
