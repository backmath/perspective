defmodule Perspective.TestSupport do
  def call_repeatedly(function, timeout \\ 1000, delay \\ 50, first_call \\ DateTime.utc_now()) do
    if should_keep_looking?(timeout, first_call) do
      try do
        function.()
      rescue
        _ ->
          Process.sleep(delay)
          call_repeatedly(function, timeout, delay, first_call)
      catch
        _, _ ->
          Process.sleep(delay)
          call_repeatedly(function, timeout, delay, first_call)
      end
    else
      function.()
    end
  end

  defp should_keep_looking?(timeout, first_call) do
    DateTime.compare(now(), timeout_date(timeout, first_call)) == :lt
  end

  defp timeout_date(timeout, first_call), do: DateTime.add(first_call, timeout, :millisecond)
  defp now, do: DateTime.utc_now()
end
