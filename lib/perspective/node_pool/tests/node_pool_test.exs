defmodule Perspective.NodePool.Test do
  use ExUnit.Case
  use Perspective.SetUniqueAppID

  defmodule Example do
    use Perspective.NodePool

    index(:email, %{email: email}) do
      email
    end
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
    assert {:error, %Perspective.NodePool.NodeNotFound{search: [:id, "abc-123"]}} = Example.get("abc-123")
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

  test "indexing by email works" do
    node = %{id: "node/example", email: "josh@backmath.com"}

    assert :ok == Example.put(node)
    assert node == Example.find({:email, "josh@backmath.com"})

    assert {:error,
            %Perspective.NodePool.NodeNotFound{
              search: [:email, "missing@backmath.com"],
              node_pool: Perspective.NodePool.Test.Example
            }} ==
             Example.find({:email, "missing@backmath.com"})
  end

  test "removing from an index" do
    node = %{id: "node/example", email: "josh@backmath.com"}

    assert :ok == Example.put(node)
    assert node == Example.find({:email, "josh@backmath.com"})

    assert :ok == Example.delete("node/example")

    assert {:error,
            %Perspective.NodePool.NodeNotFound{
              search: [:email, "josh@backmath.com"],
              node_pool: Perspective.NodePool.Test.Example
            }} == Example.find({:email, "josh@backmath.com"})
  end

  test "a missing domain node yields an error" do
    assert {:error,
            %Perspective.NodePool.NodeNotFound{search: [:id, "missing"], node_pool: Perspective.NodePool.Test.Example}} ==
             Example.get("missing")
  end
end
