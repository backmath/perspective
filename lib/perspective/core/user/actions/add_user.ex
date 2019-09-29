defmodule Perspective.Core.AddUser do
  use Perspective.ActionRequest

  domain_event(Perspective.Core.UserAdded, "1.0")

  defmodule Data do
    use Vex.Struct
    defstruct [:username, :password, :password_confirmation]

    validates(:username, presence: true)
    validates(:password, presence: true)
    validates(:password_confirmation, &Data.matches_password_confirmation/2)

    def matches_password_confirmation(password_confirmation, %{password: password}) do
      case password_confirmation do
        ^password -> :ok
        _no_match -> {:error, :password_and_password_confirmation_do_not_match}
      end
    end
  end

  validate_syntax(%{data: data}) do
    Vex.errors(struct(Data, data))
  end

  authorize(%{actor_id: "user/anonymous"}) do
    true
  end

  authorize(%{actor_id: _}) do
    false
  end

  transform_data(%{data: data}) do
    %{
      user_id: "user/" <> UUID.uuid4(),
      username: data.username,
      password_hash: Argon2.hash_pwd_salt(data.password)
    }
  end
end
