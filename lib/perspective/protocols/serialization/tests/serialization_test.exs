defmodule Perspective.Serialization.Test do
  use ExUnit.Case

  defmodule Example do
    defstruct [:data]
  end

  test "serialize/deserialize a single struct" do
    struct = %Example{data: "alpha"}

    encoded_struct = Perspective.Serialize.to_json(struct)
    decoded_struct = Perspective.Deserialize.deserialize(encoded_struct)

    assert "{\n  \"__perspective_struct__\": \"Perspective.Serialization.Test.Example\",\n  \"data\": \"alpha\"\n}" ==
             encoded_struct

    assert struct == decoded_struct
  end

  test "serialize/deserialize a list" do
    list = [%Example{data: "alpha"}]

    encoded_list = Perspective.Serialize.to_json(list)

    decoded_list = Perspective.Deserialize.deserialize(encoded_list)

    assert "[\n  {\n    \"__perspective_struct__\": \"Perspective.Serialization.Test.Example\",\n    \"data\": \"alpha\"\n  }\n]" ==
             encoded_list

    assert list == decoded_list
  end
end
