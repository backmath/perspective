defmodule Perspective.Processor.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  test "example run", context do
    Perspective.Core.start(Map.to_list(context))

    %{
      action: "Perspective.Core.AddUser",
      data: %{
        username: "user/josh",
        password: "[password]",
        password_confirmation: "[password]"
      }
    }
    |> Perspective.Processor.run("user/anonymous")

    user_token =
      Perspective.TestSupport.call_repeatedly(fn ->
        case Perspective.Core.AuthenticationTokenGenerator.generate_authentication_token(
               "user/josh",
               "[password]"
             ) do
          value -> value
        end
      end)

    %{
      action: "Perspective.Core.AddToDo",
      data: %{
        name: "Build my First ToDo"
      }
    }
    |> Perspective.Processor.run(user_token)
  end
end
