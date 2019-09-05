defmodule Perspective.EventChain.PageManifest.State do
  defstruct pages: []
  alias __MODULE__

  def new() do
    page_name = new_page_name()

    %State{
      pages: [page_name]
    }
  end

  def current_page(%State{pages: pages}) do
    List.last(pages)
  end

  def add_page(%State{pages: pages} = state) do
    next_page_name =
      State.current_page(state)
      |> next_page_number()
      |> new_page_name()

    %State{
      pages: pages ++ [next_page_name]
    }
  end

  defp next_page_number(name) do
    ~r/event-chain\.(.*)\.json/
    |> Regex.run(name)
    |> Enum.at(1)
    |> String.to_integer()
    |> Kernel.+(1)
  end

  defp new_page_name(count \\ 0) do
    number = String.pad_leading("#{count}", 7, "0")
    "event-chain.#{number}.json"
  end
end
