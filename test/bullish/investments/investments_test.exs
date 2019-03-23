defmodule Bullish.InvestmentsTest do
  @moduledoc false
  use Bullish.DataCase

  # alias Bullish.Investments

  describe "portfolios" do
    # alias Bullish.Investments.Portfolio

    @valid_attrs %{current_value: 120.5, investment: 120.5, stocks: %{}}
    @update_attrs %{current_value: 456.7, investment: 456.7, stocks: %{}}
    @invalid_attrs %{current_value: nil, investment: nil, stocks: nil}
  end
end
