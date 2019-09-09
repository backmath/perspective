defmodule Perspective.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  test "test a basic perspective call" do
    Core.start()

    %{
      action: "Core.AddUser",
      data: %{
        username: "user/josh",
        password: "[password]",
        password_confirmation: "[password]"
      }
    }
    |> Perspective.call()

    user_token =
      Perspective.TestSupport.call_repeatedly(fn ->
        case Perspective.AuthenticationTokenGenerator.generate_authentication_token("user/josh", "[password]") do
          {:error, _} -> raise "try again"
          value -> value
        end
      end)

    Perspective.DomainPool.call(:state)

    %{
      action: "Core.AddToDo",
      data: %{
        name: "Build my First ToDo"
      }
    }
    |> Perspective.call(user_token)
  end
end
