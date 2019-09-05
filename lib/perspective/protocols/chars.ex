defimpl String.Chars, for: Tuple do
  def to_string(tuple) do
    opts = struct(Inspect.Opts, [])
    doc = Inspect.Algebra.group(Inspect.Algebra.to_doc(tuple, opts))

    Inspect.Algebra.format(doc, 10000)
    |> Kernel.to_string()
  end
end
