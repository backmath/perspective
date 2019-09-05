defmodule Perspective.Reactor.Names do
  def supervisor(name) do
    Module.concat([name, Supervisor])
  end

  def backup_server(name) do
    Module.concat([name, BackupServer])
  end

  def backup_debouncer(name) do
    Module.concat([name, BackupDebouncer])
  end

  def server(name) do
    Module.concat([name, Server])
  end
end
