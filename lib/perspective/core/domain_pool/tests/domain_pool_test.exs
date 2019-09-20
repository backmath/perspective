defmodule Perspective.Core.DomainPool.Test do
  use ExUnit.Case, async: true
  use Perspective.SetUniqueAppID

  setup do
    Perspective.Core.start()
    :ok
  end

  test "can set, get a domain node" do
    node = %{id: "abc-123", example: :node}

    assert {:ok, node} == Perspective.Core.DomainPool.put(node)
    assert {:ok, node} == Perspective.Core.DomainPool.get("abc-123")
  end

  test "can delete a domain node" do
    node = %{id: "abc-123", example: :node}

    assert {:ok, node} == Perspective.Core.DomainPool.put(node)

    assert {:ok, nil} == Perspective.Core.DomainPool.delete(node)
  end

  test "can put!, get! a domain node" do
    node = %{id: "abc-123", example: :node}

    assert node == Perspective.Core.DomainPool.put!(node)
    assert node == Perspective.Core.DomainPool.get!("abc-123")
  end

  test "get! with a missing node raises an error" do
    assert_raise Perspective.Core.DomainPool.NodeNotFound, fn ->
      Perspective.Core.DomainPool.get!("missing")
    end
  end

  test "a missing domain node yields an error" do
    assert {:error, %Perspective.Core.DomainPool.NodeNotFound{id: "missing"}} ==
             Perspective.Core.DomainPool.get("missing")
  end
end
