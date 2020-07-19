defmodule Perspective.NilPipe do
  def nil_pipe(result, function) when is_function(function) do
    case result do
      nil -> function.()
      result -> result
    end
  end
end
