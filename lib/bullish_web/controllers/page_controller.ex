defmodule BullishWeb.PageController do
  use BullishWeb, :controller

  def index(conn, _params) do
    IO.puts("**~~~~~~~~ INSPECTING CONN ~~~~~~~~**")
    IO.inspect(conn)
    render(conn, "index.html")
  end

  def search(conn, %{"symbol" => symbol}) do
    stock = Bullish.Api.Server.get_price(:iex_server, symbol)
    render(conn, stock: stock)
  end
end
