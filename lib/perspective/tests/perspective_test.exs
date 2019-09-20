defmodule Perspective.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  test "test a basic perspective call" do
    Perspective.Core.start()

    %{
      action: "Perspective.Core.AddUser",
      data: %{
        username: "user/josh",
        password: "[password]",
        password_confirmation: "[password]"
      }
    }
    |> Perspective.call()

    user_token =
      Perspective.TestSupport.call_repeatedly(fn ->
        case Perspective.Core.AuthenticationTokenGenerator.generate_authentication_token(
               "user/josh",
               "[password]"
             ) do
          {:error, _} -> raise "user lookup and token generation failed"
          value -> value
        end
      end)

    %{
      action: "Perspective.Core.AddToDo",
      data: %{
        name: "Build my First ToDo"
      }
    }
    |> Perspective.call(user_token)
  end
end
