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

  test "can set, get a domain node" do
    node = %{id: "abc-123", example: :node}

    assert {:ok, node} == Example.put(node)
    assert {:ok, node} == Example.get("abc-123")
  end

  test "can delete a domain node" do
    node = %{id: "abc-123", example: :node}

    assert {:ok, node} == Example.put(node)

    assert {:ok, nil} == Example.delete(node)
  end

  test "can put!, get! a domain node" do
    node = %{id: "abc-123", example: :node}

    assert node == Example.put!(node)
    assert node == Example.get!("abc-123")
  end

  test "get! with a missing node raises an error" do
    assert_raise Perspective.NodePool.NodeNotFound, fn ->
      Example.get!("missing")
    end
  end

  test "a missing domain node yields an error" do
    assert {:error, %Perspective.NodePool.NodeNotFound{id: "missing", node_pool: Perspective.NodePool.Test.Example}} ==
             Example.get("missing")
  end

  test "" do
  end
end
