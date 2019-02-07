defmodule Perspective.DomainPool.Test do
  use ExUnit.Case

  test "can be instantiated" do
    {:ok, pid} = Perspective.DomainPool.start()
    assert pid
  end

  test "can set, get a domain node" do
    {:ok, _pid} = Perspective.DomainPool.start()

    node = %{id: "abc-123", example: :node}

    assert {:ok, node} == Perspective.DomainPool.put(node)
    assert {:ok, node} == Perspective.DomainPool.get("abc-123")
  end

  test "can delete a domain node" do
    {:ok, _pid} = Perspective.DomainPool.start()

    node = %{id: "abc-123", example: :node}

    assert {:ok, node} == Perspective.DomainPool.put(node)

    assert {:ok, nil} == Perspective.DomainPool.delete(node)
  end

  test "a missing domain node yields an error" do
    {:ok, _pid} = Perspective.DomainPool.start()

    assert {:error, %Perspective.NodeNotFound{id: "missing"}} == Perspective.DomainPool.get("missing")
  end
end
