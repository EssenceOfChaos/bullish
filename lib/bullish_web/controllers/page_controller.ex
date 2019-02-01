defmodule BullishWeb.PageController do
  use BullishWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
