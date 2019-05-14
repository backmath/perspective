defmodule Perspective.Encryption.Test do
  use ExUnit.Case

  test "encryption/decryption" do
    encrypted_binary = Perspective.Encryption.encrypt("example_data")

    assert 3 = String.split(encrypted_binary, ".") |> length()
    assert false == String.contains?(encrypted_binary, "example_data")

    assert "example_data" == Perspective.Encryption.decrypt(encrypted_binary)
  end

  test "throw an error for a failed decryption" do
    # @todo
  end
end
