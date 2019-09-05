defmodule Perspective.Reactor.InvalidEnabledBackupsConfiguration do
  defexception [:reactor, :value]

  def exception(reactor, value) do
    %__MODULE__{
      reactor: reactor,
      value: value
    }
  end

  def message(%__MODULE__{reactor: reactor, value: value}) do
    "The @enabled_backups value for #{reactor} is #{value}. Only :all, :regular, :crash, or :none are accepted"
  end
end
