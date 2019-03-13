defmodule Bullish.Investments.Portfolio do
  @moduledoc """
  The Portfolio data model
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "portfolios" do
    field :current_value, :float
    field :investment, :float
    field :stocks, :map
    # field :user_id, :id
    belongs_to(:user, Bullish.Accounts.User)
    timestamps()
  end

  @doc false
  def changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:stocks, :investment, :current_value])
    |> validate_required([:stocks])
  end
end
