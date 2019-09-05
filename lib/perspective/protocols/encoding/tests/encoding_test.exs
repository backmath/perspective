defmodule Perspective.Encoding.Test do
  use ExUnit.Case, async: true

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

  test "encode/decode a nested struct" do
    struct = %Example{data: %Example{data: %Example{data: "alpha"}}}

    encoded_struct = Perspective.Encode.encode(struct)
    decoded_struct = Perspective.Decode.decode(encoded_struct)

    assert %{
             __perspective_struct__: "Perspective.Encoding.Test.Example",
             data: %{
               __perspective_struct__: "Perspective.Encoding.Test.Example",
               data: %{__perspective_struct__: "Perspective.Encoding.Test.Example", data: "alpha"}
             }
           } == encoded_struct

    assert %Perspective.Encoding.Test.Example{
             data: %Perspective.Encoding.Test.Example{data: %Perspective.Encoding.Test.Example{data: "alpha"}}
           } == decoded_struct
  end

  test "encode/decode a map" do
    encoded_map = Perspective.Encode.encode(%{some: "value"})
    decoded_map = Perspective.Decode.decode(encoded_map)

    assert %{some: "value"} = encoded_map
    assert %{some: "value"} = decoded_map
  end

  test "encode/decode an atom" do
    encoded_atom = Perspective.Encode.encode(:an_atom)
    decoded_atom = Perspective.Decode.decode(encoded_atom)

    assert :an_atom == encoded_atom
    assert :an_atom == decoded_atom
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

  test "serialize a DateTime" do
    date = DateTime.utc_now()

    encoded_date = Perspective.Encode.encode(date)

    decoded_date = Perspective.Decode.decode(encoded_date)

    assert decoded_date =~ ~r/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}\.\d*/
  end
end
