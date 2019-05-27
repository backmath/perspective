defmodule Perspective.EventChain.Reader.Test do
  use ExUnit.Case

  # setup do
  #   # Perspective.EventChain.PageManifest.load()
  # end

  defmodule Example do
    defstruct [:id]
  end

  test "new" do
    Perspective.EventChain.apply_event(%Example{id: "a"})
    Perspective.EventChain.apply_event(%Example{id: "b"})
    Perspective.EventChain.apply_event(%Example{id: "c"})
    Perspective.EventChain.apply_event(%Example{id: "d"})

    Process.sleep(25)

    result = Perspective.EventChain.Reader.since("b") |> Enum.to_list()

    assert [%Example{id: "c"}, %Example{id: "d"}] == result
  end
end
