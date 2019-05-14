defmodule Perspective.Encryption do
  def encrypt(data) do
    {encryption_key, authentication_data} = Perspective.EncryptionConfiguration.data()
    Perspective.Encryptor.encrypt(data, encryption_key, authentication_data)
  end

  def decrypt(data) do
    {encryption_key, authentication_data} = Perspective.EncryptionConfiguration.data()
    Perspective.Decryptor.decrypt(data, encryption_key, authentication_data)
  end
end
