defmodule BullishWeb.PortfolioControllerTest do
  @moduledoc false
  use BullishWeb.ConnCase

  alias Bullish.Investments

  @create_attrs %{current_value: 120.5, investment: 120.5, stocks: %{}}
  @update_attrs %{current_value: 456.7, investment: 456.7, stocks: %{}}
  @invalid_attrs %{current_value: nil, investment: nil, stocks: nil}

  def fixture(:portfolio) do
    {:ok, portfolio} = Investments.create_portfolio(@create_attrs)
    portfolio
  end

  describe "index" do
    test "lists all portfolios", %{conn: conn} do
      conn = get(conn, Routes.portfolio_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Portfolios"
    end
  end

  describe "new portfolio" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.portfolio_path(conn, :new))
      assert html_response(conn, 200) =~ "New Portfolio"
    end
  end

  describe "create portfolio" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.portfolio_path(conn, :create), portfolio: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.portfolio_path(conn, :show, id)

      conn = get(conn, Routes.portfolio_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Portfolio"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.portfolio_path(conn, :create), portfolio: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Portfolio"
    end
  end

  describe "edit portfolio" do
    setup [:create_portfolio]

    test "renders form for editing chosen portfolio", %{conn: conn, portfolio: portfolio} do
      conn = get(conn, Routes.portfolio_path(conn, :edit, portfolio))
      assert html_response(conn, 200) =~ "Edit Portfolio"
    end
  end

  describe "update portfolio" do
    setup [:create_portfolio]

    test "redirects when data is valid", %{conn: conn, portfolio: portfolio} do
      conn = put(conn, Routes.portfolio_path(conn, :update, portfolio), portfolio: @update_attrs)
      assert redirected_to(conn) == Routes.portfolio_path(conn, :show, portfolio)

      conn = get(conn, Routes.portfolio_path(conn, :show, portfolio))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, portfolio: portfolio} do
      conn = put(conn, Routes.portfolio_path(conn, :update, portfolio), portfolio: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Portfolio"
    end
  end

  describe "delete portfolio" do
    setup [:create_portfolio]

    test "deletes chosen portfolio", %{conn: conn, portfolio: portfolio} do
      conn = delete(conn, Routes.portfolio_path(conn, :delete, portfolio))
      assert redirected_to(conn) == Routes.portfolio_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.portfolio_path(conn, :show, portfolio))
      end
    end
  end

  defp create_portfolio(_) do
    portfolio = fixture(:portfolio)
    {:ok, portfolio: portfolio}
  end
end
