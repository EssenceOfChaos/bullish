defmodule Bullish.Api.ServerTest do
  @moduledoc """
    Unit Testing for the ApiServer
  """
  use ExUnit.Case, async: true
  alias Bullish.Api.Server

  # "setup_all" is called once per module before any test runs
  setup_all do
    IO.puts("Starting AssertionTest")
    :ok
  end

  describe "Testing API" do
    setup do
      IO.puts("This is a setup callback for #{inspect(self())}")

      on_exit(fn ->
        IO.puts("This is invoked once the test is done. Process: #{inspect(self())}")
      end)
    end

    test "GenServer started correctly" do
      # Check the GenServer is started with empty map
      res = :sys.get_state(:iex_server)
      assert res != nil
    end

    test "GenServer can fetch stock data" do
      facebook = Server.get_price(:iex_server, "fb")
      assert is_binary(facebook) == true
    end

    test "GenServer stores stock prices in memory" do
      Server.get_price(:iex_server, "aapl")
      Server.get_price(:iex_server, "tsla")
      # store state in var called memory
      memory = Server.get_state(:iex_server)

      assert is_map(memory) == true
      assert map_size(memory) >= 2
      assert Map.has_key?(memory, "aapl") == true
      assert Map.has_key?(memory, "tsla") == true
    end

    test "GenServer automatically restarts after it crashes" do
      # get the current process id
      pid = Process.whereis(:iex_server)
      assert is_pid(pid) == true

      # kill the GenServer to simulate a crash
      Process.exit(pid, :kill)

      # check the GenServer has restarted
      new_pid = Process.whereis(:iex_server)

      # make sure the pids are different
      assert is_pid(new_pid)
    end
  end
end
