defmodule Core.AddUser.Test do
  use ExUnit.Case

  test "transforms into an event" do
    event = Core.AddUser.transform(valid_action())

    assert %Core.UserAdded{username: "josh@backmath.com"} = event
  end

  test "username is required" do
    result =
      valid_action()
      |> Map.put(:username, "")
      |> Core.AddUser.valid?()

    assert false == result
  end

  test "password is required" do
    result =
      valid_action()
      |> Map.put(:password, "")
      |> Core.AddUser.valid?()

    assert false == result
  end

  test "password_confirmation matches the password" do
    result =
      valid_action()
      |> Map.put(:password_confirmation, "def-456-hij%")
      |> Core.AddUser.valid?()

    assert false == result
  end

  test "the valid action is indeed valid" do
    assert Core.AddUser.valid?(valid_action())
  end

  defp valid_action do
    %Core.AddUser{
      username: "josh@backmath.com",
      password: "abc-123-xyz!",
      password_confirmation: "abc-123-xyz!"
    }
  end
end
