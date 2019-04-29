defmodule Perspective.Reactor.MacroParser do
  def capture_event_name(ast) do
    Enum.reduce_while(types(), nil, fn func, _ ->
      try do
        result = func.(ast)
        {:halt, result}
      rescue
        MatchError ->
          {:cont, nil}
      end
    end)
  end

  defp types do
    [
      &type_1/1,
      &type_2/1
    ]
  end

  defp type_1(ast) do
    {:%, _,
     [
       aliases,
       _
     ]} = ast

    aliases
  end

  defp type_2(ast) do
    {:=, _,
     [
       {:%, _,
        [
          aliases,
          _
        ]},
       _
     ]} = ast

    aliases
  end
end
