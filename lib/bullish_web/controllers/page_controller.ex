defmodule BullishWeb.PageController do
  use BullishWeb, :controller

  def index(conn, _params) do
    sectors = Bullish.Api.Service.sectorPerformance()
    IO.puts("**~~~~~~~~ INSPECTING CONN ~~~~~~~~**")
    IO.inspect(conn)
    render(conn, "index.html", sectors: sectors)
  end

  def test(conn, _params) do
    render(conn, "test.html")
  end

  def search(conn, %{"symbol" => symbol}) do
    stock = Bullish.Api.Server.get_price(:iex_server, symbol)
    render(conn, stock: stock)
  end
end
