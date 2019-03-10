defmodule Perspective.Guardian do
  use Guardian, otp_app: :perspective

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    {:ok, claims["sub"]}
  end
end
