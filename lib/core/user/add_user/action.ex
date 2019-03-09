defmodule Core.AddUser do
  use Perspective.Action

  defstruct [:username, :password, :password_confirmation]

  validates(:username, presence: true)
  validates(:password, presence: true)
  validates(:password_confirmation, &Core.AddUser.matches_password_confirmation/2)

  transform(action) do
    %Core.UserAdded{username: action.username}
    |> Map.put(:password_hash, Argon2.hash_pwd_salt(action.password))
  end

  def matches_password_confirmation(password_confirmation, %{password: password}) do
    case password_confirmation do
      ^password -> :ok
      _no_match -> {:error, :password_and_password_confirmation_do_not_match}
    end
  end
end
