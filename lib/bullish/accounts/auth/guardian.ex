defmodule Bullish.Accounts.Auth.Guardian do
  @moduledoc """
  The Guardian implementation module
  """
  use Guardian, otp_app: :bullish
  alias Bullish.Accounts

  def subject_for_token(resource, _claims), do: {:ok, to_string(resource.id)}

  def resource_from_claims(claims) do
    id = claims["sub"]
    user = Accounts.get_user(id)
    {:ok, user}
  end
end
