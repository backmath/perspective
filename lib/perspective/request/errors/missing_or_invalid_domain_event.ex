defmodule Perspective.ActionRequest.MissingOrInvalidDomainEvent do
  defexception module: ""
  import Perspective.StripElixir

  def exception(module: module) do
    %__MODULE__{
      module: module
    }
  end

  def message(%__MODULE__{module: module}) do
    """
    Missing Domain Event Name and Version

    Every action request requires an associated event name and version.

    This will be used for transformation from a request to event.

    To fix:

    defmodule #{strip_elixir(module)} do
      use Perspective.ActionRequest

      domain_event(#{strip_elixir(module)}[PastTense], "1.0") <--
    end
    """
  end
end
