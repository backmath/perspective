defmodule Perspective.Reactor.Names.Test do
  use ExUnit.Case, async: true

  defmodule Example do
    defstruct [:id]
  end

  test "supervisor generates correctly" do
    assert Perspective.Reactor.Names.Test.Example.Supervisor == Perspective.Reactor.Names.supervisor(Example)
  end

  test "backup_server generates correctly" do
    assert Perspective.Reactor.Names.Test.Example.BackupServer == Perspective.Reactor.Names.backup_server(Example)
  end

  test "server generates correctly" do
    assert Perspective.Reactor.Names.Test.Example.Server == Perspective.Reactor.Names.server(Example)
  end

  test "debouncer generates correctly" do
    assert Perspective.Reactor.Names.Test.Example.BackupDebouncer == Perspective.Reactor.Names.backup_debouncer(Example)
  end
end
