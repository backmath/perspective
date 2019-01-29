defmodule Perspective.DomainPool.DomainNode.Test do
  use ExUnit.Case
  alias Perspective.DomainPool.DomainNode, as: Subject

  setup_all do
    {:ok, _pid} = Perspective.DomainPool.Registry.start_link
    :ok
  end

  setup do
    random_id = :crypto.strong_rand_bytes(4) |> Base.encode64

    {:ok, random_id: random_id}
  end

  test "can register a node and returns the id" do
    {:ok, id} = Subject.register("123", %{abc: 123})

    assert %{abc: 123} == Subject.data(id)
  end

  test "will return an already registered node id" do
    {:ok, id1} = Subject.register("123", %{abc: 123})
    {:ok, id2} = Subject.register("123", %{abc: 123})

    assert id1 == id2
  end

  test "can be checked out by the same process", %{random_id: id} do
    {:ok, id} = Subject.register(id, %{abc: 123})

    pid1 = spawn(fn -> nil end)

    assert {:ok, {:checked_out_by, pid1}} == Subject.checkout(id, pid1)
    assert {:ok, {:checked_out_by, pid1}} == Subject.checkout(id, pid1)
  end

  test "fails if checked out by a different process", %{random_id: id} do
    {:ok, id} = Subject.register(id, %{abc: 123})

    pid1 = spawn(fn -> nil end)
    pid2 = spawn(fn -> nil end)

    assert {:ok, {:checked_out_by, pid1}} == Subject.checkout(id, pid1)
    assert {:error, {:checked_out_by, pid1}} == Subject.checkout(id, pid2)
  end

  test "a domain node may only be updated by it's checked out process", %{random_id: id} do
    {:ok, id} = Subject.register(id, %{abc: 123})

    pid = spawn(fn -> nil end)
    assert {:error, {:not_checked_out}} = Subject.update(pid, id, %{xyz: 789})

    {:ok, {:checked_out_by, pid}} = Subject.checkout(id, pid)
    assert {:ok, id} == Subject.update(pid, id, %{xyz: 789})
  end

  test "a domain node rejects an update from another checked out process", %{random_id: id} do
    {:ok, id} = Subject.register(id, %{abc: 123})

    pid1 = spawn(fn -> nil end)
    {:ok, {:checked_out_by, pid1}} = Subject.checkout(id, pid1)

    pid2 = spawn(fn -> nil end)
    assert {:error, {:checked_out_by, pid1}} == Subject.update(pid2, id, %{xyz: 789})

    Subject.checkin(id, pid1)
    Subject.checkout(id, pid2)

    assert {:ok, id} == Subject.update(pid2, id, %{xyz: 789})
  end

  test "a domain node may only be checked in by another process", %{random_id: id} do
    {:ok, id} = Subject.register(id, %{abc: 123})

    pid1 = spawn(fn -> nil end)
    assert {:ok, {:checked_out_by, pid1}} = Subject.checkout(id, pid1)

    pid2 = spawn(fn -> nil end)
    assert {:error, {:checked_out_by, pid1}} = Subject.checkin(id, pid2)

    assert {:ok, id} = Subject.checkin(id, pid1)
  end

  test "when a process that checks out a node dies, the domain node is automatically checked back in", %{random_id: id} do
    {:ok, id} = Subject.register(id, %{abc: 123})
    pid = spawn(fn -> nil end)
    assert {:ok, {:checked_out_by, pid}} = Subject.checkout(id, pid)

    # Process.exit(pid, :kill)
    # assert {:error, {:not_checked_out}} = Subject.update(pid, id, %{})
  end

  test "missing node" do

  end
end
