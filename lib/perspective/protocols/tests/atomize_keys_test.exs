defmodule Perspective.AtomizeKeys.Test do
  use ExUnit.Case

  test "atomize a nested map" do
    subject = %{
      "alpha" => :alpha,
      "data" => %{
        "beta" => :beta,
        gamma: :gamma
      }
    }

    result = Perspective.AtomizeKeys.atomize_keys(subject)

    expected = %{
      alpha: :alpha,
      data: %{
        beta: :beta,
        gamma: :gamma
      }
    }

    assert expected == result
  end
end
