defmodule Bullish.Accounts.User do

  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :auth_id, :string
    field :avatar, :string
    field :display_name, :string
    field :email, :string
    field :name, :string
    field(:play_balance, :integer, default: 5000)
    field :rank, :integer
    field :watch_list, {:array, :string}

    has_one(:portfolios, Bullish.Investments.Portfolio)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:auth_id, :avatar, :name, :email, :display_name, :play_balance, :rank, :watch_list])
    |> validate_required([:auth_id, :avatar, :name])
  end
end
