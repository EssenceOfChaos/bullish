defmodule BullishWeb.PortfolioControllerTest do
  @moduledoc false
  use BullishWeb.ConnCase

  # alias Bullish.Investments

  @create_attrs %{current_value: 120.5, investment: 120.5, stocks: %{}}
  @update_attrs %{current_value: 456.7, investment: 456.7, stocks: %{}}
  @invalid_attrs %{current_value: nil, investment: nil, stocks: nil}
end
