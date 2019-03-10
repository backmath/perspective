defmodule Perspective.Test do
  use ExUnit.Case

  test "test a basic perspective call" do
    %{
      action: "Core.AddUser",
      data: %{
        username: "josh@backmath.com",
        password:
          "RnaPxBakGM#seG9ScD%9UDBx$^fRz*7qDw3Nte8WKKc2E!YMbGwSr59g^W8^9e9uVZPEcxBAhSeSUGH*Vt$2NNghuTFB5fcVjr5w",
        password_confirmation:
          "RnaPxBakGM#seG9ScD%9UDBx$^fRz*7qDw3Nte8WKKc2E!YMbGwSr59g^W8^9e9uVZPEcxBAhSeSUGH*Vt$2NNghuTFB5fcVjr5w"
      }
    }
    |> Perspective.call()
  end
end
