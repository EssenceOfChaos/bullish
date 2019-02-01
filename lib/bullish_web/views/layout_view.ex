defmodule BullishWeb.LayoutView do
  use BullishWeb, :view

  @spec date() :: integer()
  def date() do
    datetime = NaiveDateTime.utc_now()
    datetime.year
  end

end
