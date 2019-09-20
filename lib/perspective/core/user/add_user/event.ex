defmodule Perspective.Core.UserAdded do
  use Perspective.DomainEvent

  @action_request Perspective.Core.AddUser

  defmodule Data do
    defstruct [:user_id, :username, :password_hash]
  end
end
