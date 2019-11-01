defmodule Perspective.Supervisor.Test do
  use ExUnit.Case, async: true

  defmodule Example do
    use Perspective.Supervisor

    children do
      []
    end
  end

  test "starting a supervisor with an options list can be found by the provided app_id" do
    Perspective.Supervisor.Test.Example.start_link(app_id: "com.app.id")

    assert [] = Supervisor.which_children({:global, "com.app.id.Perspective.Supervisor.Test.Example"})
  end

  test "starting a supervisor with an options map can be found by the provided app_id" do
    Perspective.Supervisor.Test.Example.start_link(%{app_id: "com.app.id"})

    assert [] = Supervisor.which_children({:global, "com.app.id.Perspective.Supervisor.Test.Example"})
  end

  test "a supervisor started without an app_id simply uses its own stringed name" do
    Perspective.Supervisor.Test.Example.start_link()

    assert [] = Supervisor.which_children({:global, "Perspective.Supervisor.Test.Example"})
  end

  defmodule FullExample do
    use Perspective.Supervisor

    defmodule Server do
      use Perspective.GenServer
    end

    children do
      [Server]
    end
  end

  test "supplying a server will provide its children with the correct configuration" do
    Perspective.Supervisor.Test.FullExample.start_link(%{app_id: "com.app.id.FullExample"})

    assert [
             {Perspective.Supervisor.Test.FullExample.Server, pid, :worker,
              [Perspective.Supervisor.Test.FullExample.Server]}
           ] = Supervisor.which_children({:global, "com.app.id.FullExample.Perspective.Supervisor.Test.FullExample"})

    assert name = GenServer.call(pid, :app_id)
  end

  test "using Perspective.Supervisor expects children macro to be called" do
    assert_raise(Perspective.Supervisor.IncorrectConfiguration, fn ->
      defmodule CorrectExample do
        use Perspective.Supervisor
      end
    end)
  end

  test "using Perspective.Supervisor expects children to be a list" do
    assert_raise(Perspective.Supervisor.IncorrectConfiguration, fn ->
      defmodule IncorrectExample do
        use Perspective.Supervisor

        children do
          :incorrect
        end
      end
    end)
  end
end
