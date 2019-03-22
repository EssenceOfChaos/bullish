defmodule Bullish.Api.Service do
  @moduledoc """
    Defines an API to interact with the GenServer
  """
  alias Bullish.Api.Server
  # @v1_sector_url "https://api.iextrading.com/1.0/stock/market/sector-performance"
  @base_url "https://cloud.iexapis.com/beta/"
  @sector_path "stock/market/sector-performance"

  def batch_quote(%{"stocks" => portfolio_params}) do
    portfolio_params
    |> Enum.each(fn stock ->
      Server.get_price(:iex_server, stock)
    end)

    Server.get_state(:iex_server)
  end

  def sectorPerformance() do
    case HTTPoison.get(@base_url <> @sector_path <> "?token=" <> System.get_env("IEX_TOKEN")) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  defp process_response_body(body) do
    body
    |> Poison.decode!()
    |> IO.inspect()
  end
end

# request:
# https://cloud.iexapis.com/beta/tops?token=pk_40c6c71966a445cca7038a5445fd54a0&symbols=aapl

# response:
# [{"symbol":"AAPL","sector":"electronictechnology","securityType":"cs","bidPrice":0,"bidSize":0,"askPrice":0,"askSize":0,"lastUpdated":1550786400000,"lastSalePrice":171.03,"lastSaleSize":233,"lastSaleTime":1550782795839,"volume":322195}]
