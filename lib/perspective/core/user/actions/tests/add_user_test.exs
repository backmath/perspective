defmodule Perspective.Core.AddUser.Test do
  use ExUnit.Case

  test "validate_syntax requires a username" do
    result =
      Perspective.Core.AddUser.new("user/anonymous", %{
        username: "",
        password: "abc-123-xyz!",
        password_confirmation: "abc-123-xyz!"
      })
      |> Perspective.Core.AddUser.validate_syntax()

    assert [{:error, :username, :presence, "must be present"}] == result
  end

  test "validate_syntax requires a password" do
    result =
      Perspective.Core.AddUser.new("user/anonymous", %{
        username: "josh@backmath.com",
        password_confirmation: "abc-123-xyz!"
      })
      |> Perspective.Core.AddUser.validate_syntax()

    assert [
             {:error, :password, :presence, "must be present"},
             {:error, :password_confirmation, :by, :password_and_password_confirmation_do_not_match}
           ] == result
  end

  test "validate_syntax requires that the password_confirmation matches the password" do
    result =
      Perspective.Core.AddUser.new("user/anonymous", %{
        username: "josh@backmath.com",
        password: "abc-123-xyz!",
        password_confirmation: "ABC-123-XYZ!"
      })
      |> Perspective.Core.AddUser.validate_syntax()

    assert [
             {:error, :password_confirmation, :by, :password_and_password_confirmation_do_not_match}
           ] == result
  end

  test "validate_syntax returns an empty list for a valid action" do
    result =
      Perspective.Core.AddUser.new("user/anonymous", %{
        username: "josh@backmath.com",
        password: "abc-123-xyz!",
        password_confirmation: "abc-123-xyz!"
      })
      |> Perspective.Core.AddUser.validate_syntax()

    assert [] == result
  end

  test "transform_data hashes the password" do
    event_data =
      Perspective.Core.AddUser.new("user/anonymous", %{
        username: "josh@backmath.com",
        password: "abc-123-xyz!",
        password_confirmation: "abc-123-xyz!"
      })
      |> Perspective.Core.AddUser.transform_data()

    assert event_data.user_id =~ ~r/user\/.*/
    assert event_data.username =~ "josh@backmath.com"
    assert event_data.password_hash =~ ~r/^\$argon2id\$.*/
  end
end
