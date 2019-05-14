defmodule Perspective.Encryptor do
  def encrypt(data, encryption_key, authentication_data) do
    generate_initialization_vector()
    |> gcm_encrypt(encryption_key, authentication_data, data)
    |> unpack_payload()
    |> encode()
  end

  defp generate_initialization_vector, do: ExCrypto.rand_bytes(32)

  defp gcm_encrypt({:ok, iv}, encryption_key, authentication_data, data) do
    ExCrypto.encrypt(encryption_key, authentication_data, iv, data)
  end

  defp unpack_payload({:ok, {_, payload}}), do: payload

  defp encode({iv, cipher_text, cipher_tag}) do
    [iv, cipher_text, cipher_tag]
    |> Enum.map(&:base64.encode/1)
    |> Enum.join(".")
  end
end
