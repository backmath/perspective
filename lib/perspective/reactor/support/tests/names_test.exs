defmodule Perspective.Reactor.Names.Test do
  use ExUnit.Case, async: true

  defmodule Example do
    defstruct [:id]
  end

  test "reactor supervisors have standardized names" do
    assert Perspective.Reactor.Names.Test.Example.Supervisor == Perspective.Reactor.Names.supervisor(Example)
  end

  test "reactor backup servers have standardized names" do
    assert Perspective.Reactor.Names.Test.Example.BackupServer == Perspective.Reactor.Names.backup_server(Example)
  end

  test "reactor servers have standardized names" do
    assert Perspective.Reactor.Names.Test.Example.Server == Perspective.Reactor.Names.server(Example)
  end

  test "reactor debouncers have standardized names" do
    assert Perspective.Reactor.Names.Test.Example.BackupDebouncer == Perspective.Reactor.Names.backup_debouncer(Example)
  end
end
