defmodule Bullish.Api.ServerTest do
  @moduledoc """
    Unit Testing for the ApiServer
  """
  use ExUnit.Case
  alias Bullish.Api.Server

  test "GenServer starts correctly" do
     # Start the Genserver and check the status
     {:ok, pid} = Server.start_link()
     res_tuple = :sys.get_status(pid)

     # Access the "status" attribute and verify it's running
     x = elem(res_tuple, 3)
     [_header, data1, _data2] = List.last(x)
     [{_, status}, {_, _}, {_, _}] = elem(data1, 1)

     assert status == :running
  end
end
