defmodule Core.User do
  use Perspective.DomainNode

  defstruct id: "", username: "", password_hash: ""
end
