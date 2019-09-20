defmodule Perspective.Core.UserAdded.Test do
  use ExUnit.Case

  test "transform_data hashes the password" do
    event_data =
      Perspective.Core.AddUser.new("user/anonymous", %{
        username: "josh@backmath.com",
        password: "abc-123-xyz!",
        password_confirmation: "abc-123-xyz!"
      })
      |> Perspective.Core.UserAdded.transform_data()

    assert event_data.user_id =~ ~r/user\/.*/
    assert event_data.username =~ "josh@backmath.com"
    assert event_data.password_hash =~ ~r/^\$argon2id\$.*/
  end
end
