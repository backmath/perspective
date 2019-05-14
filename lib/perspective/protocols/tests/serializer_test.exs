defmodule Perspective.Serializer.Test do
  use ExUnit.Case

  defmodule Example do
    defstruct [:data]
  end

  test "encode/decode" do
    struct = %Example{data: "alpha"}

    encoded_struct = Perspective.Serializer.to_json(struct)
    decoded_struct = Perspective.Serializer.from_json(encoded_struct)

    assert "{\"__perspective__struct__\":\"Elixir.Perspective.Serializer.Test.Example\",\"data\":\"alpha\"}" ==
             encoded_struct

    assert struct == decoded_struct
  end
end
