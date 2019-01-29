defmodule Perspective.DomainPool.DomainNode do
  use Agent
  require Logger
  @registry Perspective.DomainPool.Registry

  def register(id, data) do
    start_link([id: id, data: data, registry: @registry])
  end

  def data(id) do
    {:found, agent} = find_agent_by_id(id)

    Agent.get(agent, fn data ->
      data
    end)
  end

  def update(pid, id, data) do
    {:found, agent} = find_agent_by_id(id)

    update_node = fn ->
      :ok = Agent.update(agent, fn old ->
        Map.merge(old, data)
        end)
      {:ok, id}
    end

    case compare_to_checkout_pid(id, pid) do
      {:no_checkout_pid} -> {:error, {:not_checked_out}}
      {:checkout_pids_match, _pid} -> update_node.()
      {:checkout_pids_differ, existing_pid} -> {:error, {:checked_out_by, existing_pid}}
    end
  end

  def checkout(id, pid) do
    {:found, agent} = find_agent_by_id(id)

    checkout_node = fn ->
      :ok = Agent.update(agent, fn old ->
        Map.merge(old, %{
          checked_out_by: pid,
        })
        end)
      {:ok, {:checked_out_by, pid}}
    end

    case compare_to_checkout_pid(id, pid) do
      {:no_checkout_pid} -> checkout_node.()
      {:checkout_pids_match, existing_pid} -> {:ok, {:checked_out_by, existing_pid}}
      {:checkout_pids_differ, existing_pid} -> {:error, {:checked_out_by, existing_pid}}
    end
  end

  def checkin(id, pid) do
    {:found, agent} = find_agent_by_id(id)

    checkin = fn ->
      Agent.update(agent, fn old ->
        old
          |> Map.put(:checked_out_by, nil)
      end)

      {:ok, id}
    end

    case compare_to_checkout_pid(id, pid) do
      {:no_checkout_pid} -> {:ok, {:not_checked_out}}
      {:checkout_pids_match, _pid} -> checkin.()
      {:checkout_pids_differ, existing_pid} -> {:error, {:checked_out_by, existing_pid}}
    end
  end

  defp compare_to_checkout_pid(id, pid) do
    existing_pid = data(id) |> Map.get(:checked_out_by)

    cond do
      nil == existing_pid -> {:no_checkout_pid}
      pid == existing_pid -> {:checkout_pids_match, pid}
      pid != existing_pid -> {:checkout_pids_differ, existing_pid}
    end
  end

  defp find_agent_by_id(id) do
    [{agent, _data}] = Registry.lookup(@registry, id)

    {:found, agent}
  end

  defp start_link([id: id, data: data, registry: registry]) do
    name = {:via, Registry, {registry, id}}

    case Agent.start_link(fn -> data end, name: name) do
      {:ok, _pid} -> {:ok, id}
      {:error, {:already_started, _pid}} -> {:ok, id}
    end
  end
end
