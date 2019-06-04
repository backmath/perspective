defmodule Perspective.Debouncer.State do
  defstruct registry: %{}, condition: %{}

  def new do
    %__MODULE__{registry: %{}, condition: %{}}
  end

  def register(state, function_key, function) when is_atom(function_key) and is_function(function) do
    state
    |> add_function_to_registry(function_key, function)
    |> make_function_ready(function_key)
  end

  def condition(%__MODULE__{condition: condition}, function_key) do
    case Map.fetch(condition, function_key) do
      {:ok, condition} -> condition
      :error -> raise Perspective.Debouncer.MissingFunctionKey, function_key
    end
  end

  def fetch_function(%__MODULE__{registry: registry}, function_key) do
    case Map.fetch(registry, function_key) do
      {:ok, function} -> function
      :error -> raise Perspective.Debouncer.MissingFunctionKey, function_key
    end
  end

  def make_function_ready(state, function_key) do
    Map.put(state, :condition, Map.put(state.condition, function_key, :ready))
  end

  def start_debouncing(state, function_key) do
    Map.put(state, :condition, Map.put(state.condition, function_key, :debouncing))
  end

  def require_a_recall(state, function_key) do
    Map.put(state, :condition, Map.put(state.condition, function_key, :recall_when_done))
  end

  defp add_function_to_registry(state, function_key, function) do
    Map.put(state, :registry, Map.put(state.registry, function_key, function))
  end
end
