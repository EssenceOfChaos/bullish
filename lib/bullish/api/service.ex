defmodule Bullish.Api.Service do
  @moduledoc """
    Defines an API to interact with the GenServer
  """
  alias Bullish.Api.Server

  def batch_quote(%{"stocks" => portfolio_params}) do
    portfolio_params
    |> Enum.each(fn stock ->
      Server.get_price(:iex_server, stock)
    end)

    Server.get_state(:iex_server)
  end

end
