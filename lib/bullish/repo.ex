defmodule Bullish.Repo do
  use Ecto.Repo,
    otp_app: :bullish,
    adapter: Ecto.Adapters.Postgres
end
