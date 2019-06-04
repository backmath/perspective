defmodule Perspective.Debouncer.MissingFunctionKey do
  defexception [:function_key]

  def exception(function_key) do
    %__MODULE__{
      function_key: function_key
    }
  end

  def message(%__MODULE__{function_key: function_key}) do
    "The function_key (#{function_key}) was not present. An anonymous function must be registered under the given key"
  end
end
