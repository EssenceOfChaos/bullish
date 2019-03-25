defmodule Bullish.Investments do
  @moduledoc """
  The Investments context.
  """

  import Ecto.Query, warn: false
  alias Bullish.Repo
  alias Bullish.Accounts.User
  alias Bullish.Investments.Portfolio
  alias Bullish.Api.Service

  def list_portfolios do
    Repo.all(Portfolio)
  end

  def get_portfolio!(id), do: Repo.get!(Portfolio, id)

  def create_portfolio(%User{} = user, attrs \\ %{}) do
    stocks = Service.batch_quote(attrs)

    investment = Enum.reduce(stocks, 0, fn {_k, v}, acc -> v + acc end)

    %Portfolio{}
    |> Portfolio.changeset(Map.put(attrs, "stocks", stocks))
    |> Portfolio.changeset(Map.put(attrs, "investment", investment))
    |> put_user(user)
    |> Repo.insert()
  end

  def update_portfolio(%Portfolio{} = portfolio, attrs) do
    portfolio
    |> Portfolio.changeset(attrs)
    |> Repo.update()
  end

  def delete_portfolio(%Portfolio{} = portfolio) do
    Repo.delete(portfolio)
  end

  def change_portfolio(%Portfolio{} = portfolio) do
    Portfolio.changeset(portfolio, %{})
  end

  ## Private functions ##
  defp put_user(changeset, user) do
    Ecto.Changeset.put_assoc(changeset, :user, user)
  end
end
