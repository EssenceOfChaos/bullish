defmodule BullishWeb.PortfolioController do
  use BullishWeb, :controller

  alias Bullish.Investments
  alias Bullish.Investments.Portfolio

  def index(conn, _params) do
    portfolios = Investments.list_portfolios()
    render(conn, "index.html", portfolios: portfolios)
  end

  def new(conn, _params) do
    user = conn.assigns[:current_user]
    changeset = Investments.change_portfolio(%Portfolio{})
    render(conn, "new.html", user: user, changeset: changeset)
  end

  def create(conn, %{"portfolio" => portfolio_params}) do
    current_user = conn.assigns[:current_user]
    case Investments.create_portfolio(current_user, portfolio_params) do
      {:ok, portfolio} ->
        conn
        |> put_flash(:info, "Portfolio created successfully.")
        |> redirect(to: Routes.portfolio_path(conn, :show, portfolio))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    portfolio = Investments.get_portfolio!(id)
    render(conn, "show.html", portfolio: portfolio)
  end

  def edit(conn, %{"id" => id}) do
    portfolio = Investments.get_portfolio!(id)
    changeset = Investments.change_portfolio(portfolio)
    render(conn, "edit.html", portfolio: portfolio, changeset: changeset)
  end

  def update(conn, %{"id" => id, "portfolio" => portfolio_params}) do
    portfolio = Investments.get_portfolio!(id)

    case Investments.update_portfolio(portfolio, portfolio_params) do
      {:ok, portfolio} ->
        conn
        |> put_flash(:info, "Portfolio updated successfully.")
        |> redirect(to: Routes.portfolio_path(conn, :show, portfolio))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", portfolio: portfolio, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    portfolio = Investments.get_portfolio!(id)
    {:ok, _portfolio} = Investments.delete_portfolio(portfolio)

    conn
    |> put_flash(:info, "Portfolio deleted successfully.")
    |> redirect(to: Routes.portfolio_path(conn, :index))
  end
end
