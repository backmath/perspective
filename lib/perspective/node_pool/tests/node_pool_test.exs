defmodule Perspective.NodePool.Test do
  use ExUnit.Case
  use Perspective.BootAppPerTest

  defmodule Example do
    use Perspective.NodePool

    index(:email, %{email: email}) do
      email
    end
  end

  setup %{app_id: app_id} do
    Example.start_link(app_id: app_id)
    :ok
  end

  test "a node pool can set, get, and delete a domain node" do
    node = %{id: "abc-123", example: :node}

    assert :ok == Example.put(node)
    assert node == Example.get("abc-123")

    assert :ok == Example.delete("abc-123")
    assert {:error, %Perspective.NodePool.NodeNotFound{search: "abc-123"}} = Example.get("abc-123")
  end

  test "get! throws a error" do
    assert_raise(Perspective.NodePool.NodeNotFound, fn ->
      Example.get!("node/missing")
    end)
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
    assert {:error, %Perspective.NodePool.NodeNotFound{search: "missing", node_pool: Perspective.NodePool.Test.Example}} ==
             Example.get("missing")
  end

  test "emitting events" do
    Perspective.Notifications.subscribe(%Example.NodePut{})
    Perspective.Notifications.subscribe(%Example.NodeDeleted{})

    node = %{id: "abc-123", example: :node}

    assert :ok == Example.put(node)
    assert :ok == Example.delete("abc-123")

    assert_receive %Example.NodePut{node: ^node}
    assert_receive %Example.NodeDeleted{node_id: "abc-123"}
  end
end
