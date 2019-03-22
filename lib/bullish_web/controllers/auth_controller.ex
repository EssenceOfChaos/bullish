defmodule BullishWeb.AuthController do
  use BullishWeb, :controller
  alias BullishWeb.Router.Helpers

  plug(Ueberauth)

  # alias Ueberauth.Strategy.Helpers
  alias Bullish.Accounts.Auth.UserFromAuth
  alias Bullish.Accounts

  def logout(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> assign(:user_signed_in?, false)
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case UserFromAuth.find_or_create(auth) do
      {:ok, user} ->
        Accounts.find_or_add(user)

        conn
        |> put_flash(:info, "Successfully authenticated as " <> user.name <> ".")
        # |> put_session(:current_user, user) # user is an Auth0 user object
        # store user_id (user_auth.id) to retrieve user object later
        |> assign(:user_signed_in?, true)
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end
end
