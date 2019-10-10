defmodule Perspective.NodePool.Test do
  use ExUnit.Case
  use Perspective.SetUniqueAppID

  defmodule Example do
    use Perspective.NodePool
  end

  setup context do
    Example.start_link(context)
    :ok
  end

  test "a node pool can set, get, and delete a domain node" do
    node = %{id: "abc-123", example: :node}

    assert :ok == Example.put(node)
    assert node == Example.get("abc-123")

    assert :ok == Example.delete("abc-123")
    assert {:error, %Perspective.NodePool.NodeNotFound{id: "abc-123"}} = Example.get("abc-123")
  end

  test "deleting a domain node is idempotent" do
    assert {:error, %Perspective.NodePool.NodeNotFound{}} = Example.get("node/example")

    assert :ok == Example.delete("node/missing")
    assert :ok == Example.delete("node/missing")
    assert :ok == Example.delete("node/missing")

    assert {:error, %Perspective.NodePool.NodeNotFound{}} = Example.get("node/example")
  end

  test "putting a domain node is idempotent" do
    node = %{id: "node/example"}

    assert :ok == Example.put(node)
    assert :ok == Example.put(node)
    assert :ok == Example.put(node)

    assert node == Example.get("node/example")
  end

  test "a missing domain node yields an error" do
    assert {:error, %Perspective.NodePool.NodeNotFound{id: "missing", node_pool: Perspective.NodePool.Test.Example}} ==
             Example.get("missing")
  end
end
