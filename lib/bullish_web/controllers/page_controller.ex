defmodule BullishWeb.PageController do
  use BullishWeb, :controller

  def index(conn, _params) do
    IO.puts("**~~~~~~~~ INSPECTING CONN ~~~~~~~~**")
    IO.inspect(conn)
    render(conn, "index.html")
  end
end
