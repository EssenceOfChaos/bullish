defmodule Bullish.Amqp do
  # Example Rabbit MQ implementation
  @moduledoc """
  The Cloud AMQP Consumer - RabbitMQ
  """
  use GenServer
  use AMQP

  @spec start_link() :: :ignore | {:error, any()} | {:ok, pid()}
  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end

  @exchange    "gen_server_test_exchange"
  @queue       "gen_server_test_queue"
  @queue_error "#{@queue}_error"

  @spec init(any()) :: {:ok, AMQP.Channel.t()}
  def init(_opts) do
    rabbitmq_connect()
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end
# 2. Implement a callback to handle DOWN notifications from the system
# This callback should try to reconnect to the server

def handle_info({:DOWN, _, :process, _pid, _reason}, _) do
  {:ok, chan} = rabbitmq_connect()
  {:noreply, chan}
end

## Private ##

defp rabbitmq_connect do
  case Connection.open("amqp://guest:guest@localhost") do
    {:ok, conn} ->
      # Get notifications when the connection goes down
      Process.monitor(conn.pid)
      # Everything else remains the same
      {:ok, chan} = Channel.open(conn)
      setup_queue(chan)
      Basic.qos(chan, prefetch_count: 10)
      {:ok, _consumer_tag} = Basic.consume(chan, @queue)
      {:ok, chan}

    {:error, _} ->
      # Reconnection loop
      :timer.sleep(10_000)
      rabbitmq_connect()
  end
end
  defp setup_queue(chan) do
    {:ok, _} = Queue.declare(chan, @queue_error, durable: true)
    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    {:ok, _} = Queue.declare(chan, @queue,
                             durable: true,
                             arguments: [
                               {"x-dead-letter-exchange", :longstr, ""},
                               {"x-dead-letter-routing-key", :longstr, @queue_error}
                             ]
                            )
    :ok = Exchange.fanout(chan, @exchange, durable: true)
    :ok = Queue.bind(chan, @queue, @exchange)
  end

  defp consume(channel, tag, redelivered, payload) do
    number = String.to_integer(payload)
    if number <= 10 do
      :ok = Basic.ack channel, tag
      IO.puts "Consumed a #{number}."
    else
      :ok = Basic.reject channel, tag, requeue: false
      IO.puts "#{number} is too big and was rejected."
    end

  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise comsumer will stop
    # receiving messages.
    exception ->
      :ok = Basic.reject channel, tag, requeue: not redelivered
      IO.puts "Error converting #{payload} to integer"
  end
end




# iex> DataDash.Amqp.start_link
# {:ok, #PID<0.261.0>}
# iex> {:ok, conn} = AMQP.Connection.open
# {:ok, %AMQP.Connection{pid: #PID<0.165.0>}}
# iex> {:ok, chan} = AMQP.Channel.open(conn)
# {:ok, %AMQP.Channel{conn: %AMQP.Connection{pid: #PID<0.165.0>}, pid: #PID<0.177.0>}
# iex> AMQP.Basic.publish chan, "gen_server_test_exchange", "", "5"
# :ok
# Consumed a 5.
# iex> AMQP.Basic.publish chan, "gen_server_test_exchange", "", "42"
# :ok
# 42 is too big and was rejected.
# iex> AMQP.Basic.publish chan, "gen_server_test_exchange", "", "Hello, World!"
# :ok
