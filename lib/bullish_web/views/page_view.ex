defmodule BullishWeb.PageView do
  use BullishWeb, :view
  use Timex

  def handler_info(conn) do
    "Request Handled By: #{controller_module(conn)}.#{action_name(conn)}"
  end

  def connection_keys(conn) do
    conn
    |> Map.from_struct()
    |> Map.keys()
  end

  def format_time(epoch) do
    epoch
    |> DateTime.from_unix!(:millisecond)
    |> Timex.format!("%l:%M %p", :strftime)
  end

  def color_card(performance) when is_float(performance) do
    str = Float.to_string(performance)

    case String.at(str, 0) do
      "-" -> "red"
      "0" -> "green"
    end
  end

  def format_performance(performance) do
    Float.round(performance, 2)
  end
end
