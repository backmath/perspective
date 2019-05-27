defmodule Perspective.Decryptor do
  def decrypt(binary, encryption_key, authentication_data) do
    decode(binary)
    |> gcm_decrypt(encryption_key, authentication_data)
    |> unpack_payload()
  end

  defp decode(binary) do
    try do
      String.split(binary, ".")
      |> Enum.map(&:base64.decode/1)
      |> List.to_tuple()
    rescue
      ArgumentError ->
        raise Perspective.NonDecryptableData, binary

      FunctionClauseError ->
        raise Perspective.NonDecryptableData, binary
    end
  end

  defp gcm_decrypt({iv, cipher_text, cipher_tag}, encryption_key, authentication_data) do
    ExCrypto.decrypt(encryption_key, authentication_data, iv, cipher_text, cipher_tag)
  end

  defp unpack_payload({:ok, value}), do: value
  defp unpack_payload(error), do: error
end
