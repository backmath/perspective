defmodule Core.AddUser.Test do
  use ExUnit.Case

  test "validate_syntax requires a username" do
    result =
      Core.AddUser.new(%{
        username: "",
        password: "abc-123-xyz!",
        password_confirmation: "abc-123-xyz!"
      })
      |> Core.AddUser.validate_syntax()

    assert [{:error, :username, :presence, "must be present"}] == result
  end

  test "validate_syntax requires a password" do
    result =
      Core.AddUser.new(%{
        username: "josh@backmath.com",
        password_confirmation: "abc-123-xyz!"
      })
      |> Core.AddUser.validate_syntax()

    assert [
             {:error, :password, :presence, "must be present"},
             {:error, :password_confirmation, :by, :password_and_password_confirmation_do_not_match}
           ] == result
  end

  test "validate_syntax requires that the password_confirmation matches the password" do
    result =
      Core.AddUser.new(%{
        username: "josh@backmath.com",
        password: "abc-123-xyz!",
        password_confirmation: "ABC-123-XYZ!"
      })
      |> Core.AddUser.validate_syntax()

    assert [
             {:error, :password_confirmation, :by, :password_and_password_confirmation_do_not_match}
           ] == result
  end

  test "validate_syntax returns an empty list for a valid action" do
    result =
      Core.AddUser.new(%{
        username: "josh@backmath.com",
        password: "abc-123-xyz!",
        password_confirmation: "abc-123-xyz!"
      })
      |> Core.AddUser.validate_syntax()

    assert [] == result
  end
end
