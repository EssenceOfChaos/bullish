defmodule Bullish.InvestmentsTest do
  @moduledoc false
  use Bullish.DataCase

  alias Bullish.Investments

  describe "portfolios" do
    alias Bullish.Investments.Portfolio

    @valid_attrs %{current_value: 120.5, investment: 120.5, stocks: %{}}
    @update_attrs %{current_value: 456.7, investment: 456.7, stocks: %{}}
    @invalid_attrs %{current_value: nil, investment: nil, stocks: nil}

    def portfolio_fixture(attrs \\ %{}) do
      {:ok, portfolio} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Investments.create_portfolio()

      portfolio
    end

    test "get_portfolio!/1 returns the portfolio with given id" do
      portfolio = portfolio_fixture()
      assert Investments.get_portfolio!(portfolio.id) == portfolio
    end

    test "create_portfolio/1 with valid data creates a portfolio" do
      assert {:ok, %Portfolio{} = portfolio} = Investments.create_portfolio(@valid_attrs)
      assert portfolio.current_value == 120.5
      assert portfolio.investment == 120.5
      assert portfolio.stocks == %{}
    end

    test "create_portfolio/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Investments.create_portfolio(@invalid_attrs)
    end

    test "update_portfolio/2 with valid data updates the portfolio" do
      portfolio = portfolio_fixture()

      assert {:ok, %Portfolio{} = portfolio} =
               Investments.update_portfolio(portfolio, @update_attrs)

      assert portfolio.current_value == 456.7
      assert portfolio.investment == 456.7
      assert portfolio.stocks == %{}
    end

    test "update_portfolio/2 with invalid data returns error changeset" do
      portfolio = portfolio_fixture()
      assert {:error, %Ecto.Changeset{}} = Investments.update_portfolio(portfolio, @invalid_attrs)
      assert portfolio == Investments.get_portfolio!(portfolio.id)
    end

    test "delete_portfolio/1 deletes the portfolio" do
      portfolio = portfolio_fixture()
      assert {:ok, %Portfolio{}} = Investments.delete_portfolio(portfolio)
      assert_raise Ecto.NoResultsError, fn -> Investments.get_portfolio!(portfolio.id) end
    end
  end
end
