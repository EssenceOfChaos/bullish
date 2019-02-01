defmodule Bullish.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :auth_id, :string
      add :avatar, :string
      add :name, :string, null: false
      add :email, :string
      add :display_name, :string
      add :play_balance, :integer, default: 5000
      add :rank, :integer, default: 0
      add :watch_list, {:array, :string}

      timestamps()
    end

  end
end
