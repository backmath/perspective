defmodule Perspective.Core.UserAdded do
  use Perspective.DomainEvent

  defmodule Data do
    defstruct [:user_id, :username, :password_hash]
  end
end
