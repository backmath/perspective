defmodule Perspective.Core.UserAdded do
  use Perspective.DomainEvent

  @action_request Perspective.Core.AddUser

  defmodule Data do
    defstruct [:user_id, :username, :password_hash]
  end

  transform_data(%{data: data}) do
    %{
      user_id: "user/" <> UUID.uuid4(),
      username: data.username,
      password_hash: Argon2.hash_pwd_salt(data.password)
    }
  end
end
