defmodule Perspective.EncryptionConfiguration do
  use Perspective.GenServer

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

  initial_state do
    State.load()
  end

  def handle_call(:data, _from, state) do
    %State{encryption_key: encryption_key, authentication_data: authentication_data} = state

    {:reply, {encryption_key, authentication_data}, state}
  end
end
