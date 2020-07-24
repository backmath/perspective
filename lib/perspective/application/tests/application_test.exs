defmodule Perspective.Application.Test do
  use ExUnit.Case, async: true

  defmodule ExampleApplication do
    use Perspective.Application
  end

  test "application without a configured app_id fails to start" do
    old_config = Application.get_env(:perspective, Perspective.Application)

    Application.put_env(:perspective, Perspective.Application, [])

    assert_raise(Perspective.MissingAppIdConfiguration, fn ->
      ExampleApplication.start()
    end)

    Application.put_env(:perspective, Perspective.Application, old_config)
  end
end
