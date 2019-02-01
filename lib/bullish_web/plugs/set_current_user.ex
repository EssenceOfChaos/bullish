defmodule BullishWeb.Plugs.SetCurrentUser do
  import Plug.Conn
  alias Bullish.Repo
  alias Bullish.Accounts.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, _params) do
    if conn.assigns[:current_user] do
      conn
    else
      user_id = get_session(conn, :user_id)

      cond do
        is_nil(user_id) ->
          conn
          |> assign(:current_user, nil)
          |> assign(:user_signed_in?, false)

        user = Repo.get_by(User, auth_id: user_id) ->
          conn
          |> assign(:current_user, user)
          |> assign(:user_signed_in?, true)
      end
    end
  end
end
