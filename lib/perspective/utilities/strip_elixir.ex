defmodule Perspective.StripElixir do
  def strip_elixir(atom_or_string) do
    String.replace("#{atom_or_string}", ~r/^Elixir\./, "")
  end
end
