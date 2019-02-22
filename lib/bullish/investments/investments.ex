defmodule Bullish.Investments do
  @moduledoc """
  The Investments context.
  """

  import Ecto.Query, warn: false
  alias Bullish.Repo
  alias Bullish.Accounts.User
  alias Bullish.Investments.Portfolio
  alias Bullish.Api.Service

  @doc """
  Returns the list of portfolios.

  ## Examples

      iex> list_portfolios()
      [%Portfolio{}, ...]

  """
  def list_portfolios do
    Repo.all(Portfolio)
  end

  @doc """
  Gets a single portfolio.

  Raises `Ecto.NoResultsError` if the Portfolio does not exist.

  ## Examples

      iex> get_portfolio!(123)
      %Portfolio{}

      iex> get_portfolio!(456)
      ** (Ecto.NoResultsError)

  """
  def get_portfolio!(id), do: Repo.get!(Portfolio, id)

  @doc """
  Creates a portfolio.

  ## Examples

      iex> create_portfolio(%{field: value})
      {:ok, %Portfolio{}}

      iex> create_portfolio(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_portfolio(%User{} = user, attrs \\ %{}) do
    stocks = Service.batch_quote(attrs)
    #recently added
    investment = Enum.reduce(stocks, 0, fn({_k, v}, acc) -> v + acc end)
    %Portfolio{}
    |> Portfolio.changeset(Map.put(attrs, "stocks", stocks))
    |> Portfolio.changeset(Map.put(attrs, "investment", investment))#recently added
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
