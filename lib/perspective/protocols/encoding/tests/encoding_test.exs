defmodule Perspective.Encoding.Test do
  use ExUnit.Case

  defmodule Example do
    defstruct [:data]
  end

  test "encode/decode a string" do
    string = "abc"

    encoded_string = Perspective.Encode.encode(string)
    decoded_string = Perspective.Decode.decode(encoded_string)

    assert "abc" == encoded_string
    assert string == decoded_string
  end

  test "encode/decode a single struct" do
    struct = %Example{data: "alpha"}

    encoded_struct = Perspective.Encode.encode(struct)
    decoded_struct = Perspective.Decode.decode(encoded_struct)

    assert %{__perspective_struct__: "Perspective.Encoding.Test.Example", data: "alpha"} == encoded_struct
    assert %Example{data: "alpha"} == decoded_struct
  end

  test "decode a single struct with stringed keys" do
    struct = %{
      "__perspective_struct__" => "Perspective.Encoding.Test.Example",
      "data" => "alpha"
    }

    decoded_struct = Perspective.Decode.decode(struct)

    assert %Example{data: "alpha"} == decoded_struct
  end

  test "serialize/deserialize a list" do
    list = [%Example{data: "alpha"}]

    encoded_list = Perspective.Encode.encode(list)

    decoded_list = Perspective.Decode.decode(encoded_list)

    assert [%{__perspective_struct__: "Perspective.Encoding.Test.Example", data: "alpha"}] == encoded_list

    assert list == decoded_list
  end
end
