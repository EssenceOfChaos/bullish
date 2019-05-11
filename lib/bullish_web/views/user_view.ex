defmodule BullishWeb.UserView do
  use BullishWeb, :view
  alias Bullish.Api.Service
  def current_stock_prices(user_stocks) do
    Service.batch_quote(user_stocks.stocks)
  end
end
