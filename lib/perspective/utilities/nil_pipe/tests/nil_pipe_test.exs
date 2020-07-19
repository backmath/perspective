defmodule Perspective.NilPipe.Test do
  use ExUnit.Case

  test "an initial non-nil value returns that value" do
    result =
      "non-nil-value"
      |> Perspective.NilPipe.nil_pipe(fn -> nil end)
      |> Perspective.NilPipe.nil_pipe(fn -> nil end)

    assert result == "non-nil-value"
  end

  test "a middle-issued non-nil-value returns that value" do
    result =
      nil
      |> Perspective.NilPipe.nil_pipe(fn -> "non-nil-value" end)
      |> Perspective.NilPipe.nil_pipe(fn -> nil end)

    assert result == "non-nil-value"
  end

  test "a last-issued non-nil-value returns that value" do
    result =
      nil
      |> Perspective.NilPipe.nil_pipe(fn -> nil end)
      |> Perspective.NilPipe.nil_pipe(fn -> "non-nil-value" end)

    assert result == "non-nil-value"
  end
end
