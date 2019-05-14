defmodule Perspective.EncryptionConfiguration do
  use Agent

  defmodule State do
    use Perspective.Config

    defstruct [:encryption_key, :authentication_data]

    def load do
      %State{
        encryption_key: hash(config(:encryption_key)),
        authentication_data: hash(config(:authentication_data))
      }
    end

    defp hash(data) do
      :crypto.hash(:sha256, data)
    end
  end

  def start_link(_) do
    Agent.start_link(fn -> State.load() end, name: __MODULE__)
  end

  def data() do
    Agent.get(__MODULE__, fn %State{encryption_key: encryption_key, authentication_data: authentication_data} ->
      {encryption_key, authentication_data}
    end)
  end
end
