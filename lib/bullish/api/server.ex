defmodule Bullish.Api.Server do
  @moduledoc """
    Defines the Bullish API for retreiving market and stock data
  """
  use GenServer
  @url "https://api.iextrading.com/1.0/stock/{SYMBOL}/price"

  ## ------------------------------------------------- ##
  ##                   Client API                      ##
  ## ------------------------------------------------- ##
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, :ok, name: :iex_server)
  end

  def get_price(name, stock) do
    GenServer.call(name, {:stock, stock})
  end

  def get_state(name) do
    GenServer.call(name, :get_state)
  end

  def reset_state(name) do
    GenServer.cast(name, :reset_state)
  end

  def stop(name) do
    GenServer.cast(name, :stop)
  end

  ## ------------------------------------------------- ##
  ##                   Server API                      ##
  ## ------------------------------------------------- ##

  def init(:ok) do
    {:ok, %{}}
  end

  def handle_call({:stock, stock}, _from, state) do
    case price_of(stock) do
      {:ok, price} ->
        new_state = update_state(state, stock, price)
        {:reply, "#{price}", new_state}

      _ ->
        {:reply, :error, state}
    end
  end

  def handle_call(:get_state, _from, state) do
    # action, response, new state(no change)
    {:reply, state, state}
  end

  def handle_cast(:reset_state, _state) do
    # note: no response
    # action, current state(set to empty map)
    {:noreply, %{}}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def terminate(reason, stats) do
    # We could write to a file, database etc
    IO.puts("server terminated because of #{inspect(reason)}")
    inspect(stats)
    :ok
  end

  def handle_info(msg, state) do
    IO.puts("received #{inspect(msg)}")
    {:noreply, state}
  end

  ## ------------------------------------------------- ##
  ##                   Helper Functions                ##
  ## ------------------------------------------------- ##

  defp price_of(stock) do
    uri = String.replace(@url, "{SYMBOL}", stock)

    case HTTPoison.get(uri) do
      {:ok, %{status_code: 200, body: body}} -> Poison.decode(body)
      # 404 Not Found Error
      {:ok, %{status_code: 404}} -> "Not found"
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect(reason)
    end
  end

  defp update_state(old_state, stock, price) do
    case Map.has_key?(old_state, stock) do
      true ->
        Map.update!(old_state, stock, price)

      false ->
        Map.put_new(old_state, stock, price)
    end
  end
end
