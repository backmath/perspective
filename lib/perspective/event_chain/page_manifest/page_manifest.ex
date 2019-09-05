defmodule Perspective.EventChain.PageManifest do
  use Perspective.GenServer
  use Perspective.Config, Perspective.LocalFileStorage
  alias Perspective.EventChain.PageManifest.State

  initial_state do
    Perspective.EventChain.LoadPageManifest.load_manifest()
  end

  def current_page do
    call(:current_page)
  end

  def add_page do
    call(:add_page)
  end

  def pages do
    call(:pages)
  end

  def handle_call(:current_page, _, state) do
    {:reply, State.current_page(state), state}
  end

  def handle_call(:add_page, _, state) do
    new_state = State.add_page(state)
    Perspective.EventChain.SavePageManifest.run(new_state)
    {:reply, :ok, new_state}
  end

  def handle_call(:pages, _, %{pages: pages} = state) do
    {:reply, pages, state}
  end
end
