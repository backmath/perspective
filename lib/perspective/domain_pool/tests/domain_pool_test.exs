defmodule Perspective.DomainPool.Test do
  use ExUnit.Case

  test "can set, get a domain node" do
    node = %{id: "abc-123", example: :node}

    assert {:ok, node} == Perspective.DomainPool.put(node)
    assert {:ok, node} == Perspective.DomainPool.get("abc-123")
  end

  test "can delete a domain node" do
    node = %{id: "abc-123", example: :node}

    assert {:ok, node} == Perspective.DomainPool.put(node)

    assert {:ok, nil} == Perspective.DomainPool.delete(node)
  end

  test "can put!, get! a domain node" do
    node = %{id: "abc-123", example: :node}

    assert node == Perspective.DomainPool.put!(node)
    assert node == Perspective.DomainPool.get!("abc-123")
  end

  test "get! with a missing node raises an error" do
    assert_raise Perspective.DomainPool.NodeNotFound, fn ->
      Perspective.DomainPool.get!("missing")
    end
  end

  test "a missing domain node yields an error" do
    assert {:error, %Perspective.DomainPool.NodeNotFound{id: "missing"}} == Perspective.DomainPool.get("missing")
  end
end
