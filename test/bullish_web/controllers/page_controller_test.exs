defmodule BullishWeb.PageControllerTest do
  @moduledoc false
  use BullishWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Bullish Market"
  end
end
