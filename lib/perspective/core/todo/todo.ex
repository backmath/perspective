defmodule Perspective.Core.ToDo do
  use Perspective.DomainNode

  defstruct creator_id: "", id: "", name: "", completed: false

  def generate_id do
    "todo/#{UUID.uuid4()}"
  end
end
