defmodule Perspective.Debouncer.State do
  defstruct started_debouncing: nil, recalled: nil

  def new do
    %__MODULE__{started_debouncing: nil, recalled: nil}
  end

  def start_debouncing(state) do
    Map.put(state, :started_debouncing, DateTime.utc_now())
  end

  def condition(%__MODULE__{started_debouncing: nil}) do
    :ready
  end

  def condition(%__MODULE__{started_debouncing: _, recalled: nil}) do
    :debouncing
  end

  def condition(%__MODULE__{started_debouncing: started_debouncing, recalled: recalled}) do
    case DateTime.compare(started_debouncing, recalled) do
      :lt -> :recall_when_done
      :gt -> :debouncing
    end
  end

  def require_a_recall(state) do
    Map.put(state, :recalled, DateTime.utc_now())
  end
end
