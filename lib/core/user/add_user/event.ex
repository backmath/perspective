defmodule Core.UserAdded do
  use Perspective.DomainEvent

  defmodule Data do
    defstruct [:user_id, :username, :password_hash]
  end
end

defprotocol Core.UserAdded.Applier do
  def apply_to(node, event)
end

defimpl Core.UserAdded.Applier, for: Core.User do
  def apply_to(_node, event) do
    %Core.User{
      id: event.data.user_id,
      username: event.data.username
    }
  end
end
