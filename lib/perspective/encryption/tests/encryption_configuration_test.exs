defmodule Perspective.EncryptionConfiguration.Test do
  use ExUnit.Case

  test "configuration loads and hashes keys" do
    {encryption_key, authentication_data} = Perspective.EncryptionConfiguration.data()

    assert encryption_key ==
             <<191, 117, 99, 47, 181, 166, 102, 164, 204, 27, 62, 70, 83, 9, 172, 97, 51, 36, 228, 192, 134, 54, 221,
               214, 131, 58, 230, 239, 186, 92, 96, 36>>

    assert authentication_data ==
             <<185, 10, 7, 17, 106, 59, 100, 207, 196, 226, 147, 67, 102, 104, 232, 109, 30, 72, 23, 235, 225, 81, 95,
               238, 120, 67, 182, 200, 11, 188, 242, 5>>
  end
end
