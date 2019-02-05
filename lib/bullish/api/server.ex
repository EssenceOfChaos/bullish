defmodule Bullish.Api.Server do
  @moduledoc """
    Defines the Bullish API for retreiving market and stock data
  """
  use GenServer
  @url "https://api.iextrading.com/1.0/stock/{SYMBOL}/price"

  ## ------------------------------------------------- ##
  ##                   Client API                      ##
  ## ------------------------------------------------- ##
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: :iex_server)
  end

  def get_price(pid, stock) do
    GenServer.call(pid, {:stock, stock})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def reset_state(pid) do
    GenServer.cast(pid, :reset_state)
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
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
    IO.puts "server terminated because of #{inspect reason}"
    inspect stats
    :ok
  end

  def handle_info(msg, state) do
    IO.puts "received #{inspect msg}"
    {:noreply, state}
  end


  ## ------------------------------------------------- ##
  ##                   Helper Functions                ##
  ## ------------------------------------------------- ##

  defp price_of(stock) do
    uri = String.replace(@url, "{SYMBOL}", stock)
    case HTTPoison.get(uri) do
      {:ok, %{status_code: 200, body: body}} -> Poison.decode(body)
      {:ok, %{status_code: 404}} -> "Not found"# 404 Not Found Error
      {:error, %HTTPoison.Error{reason: reason}} -> IO.inspect reason
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

# iex(1)> Service.get_price(:iex_server, "aapl")
# "166.52"
# iex(2)> Service.get_state(:iex_server)
# %{"aapl" => 166.52}
# iex(3)> Process.whereis(:iex_server)
# #PID<0.389.0>
# iex(4)> Process.exit(:iex_server, :kill)
# iex(4)> Process.whereis(:iex_server) |>
# ...(4)> Process.exit(:kill)
# true
# iex(5)> Process.whereis(:iex_server)
# #PID<0.402.0>
