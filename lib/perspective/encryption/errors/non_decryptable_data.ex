defmodule Perspective.NonDecryptableData do
  defexception [:data]

  def exception(data) do
    %__MODULE__{
      data: data
    }
  end

  def message(%__MODULE__{data: data}) do
    "The supplied data could not be decrypted data: #{data}"
  end
end
