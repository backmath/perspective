defmodule Perspective.Supervisor.Test do
  use Perspective.TestCase

  defmodule Example do
    use Perspective.Supervisor

    children do
      []
    end
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

  test "starting a supervisor can be found by the provided app_id", %{app_id: app_id} do
    Perspective.Supervisor.Test.Example.start_link()
    |> elem(1)
    |> Process.info()

    assert [] = Supervisor.which_children({:global, "#{app_id}/Perspective.Supervisor.Test.Example"})
  end

  test "supplying a server will provide its children with the correct configuration", %{app_id: app_id} do
    Perspective.Supervisor.Test.FullExample.start_link()

    assert [
             {Perspective.Supervisor.Test.FullExample.Server, pid, :worker,
              [Perspective.Supervisor.Test.FullExample.Server]}
           ] = Supervisor.which_children({:global, "#{app_id}/Perspective.Supervisor.Test.FullExample"})

    assert name = GenServer.call(pid, :app_id)
  end

  test "using Perspective.Supervisor expects children to be a list" do
    defmodule IncorrectExample do
      use Perspective.Supervisor

      children do
        :incorrect
      end
    end

    assert_raise(Perspective.Supervisor.IncorrectConfiguration, fn ->
      IncorrectExample.start_link()
    end)
  end
end
