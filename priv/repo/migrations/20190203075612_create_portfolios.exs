defmodule Bullish.Repo.Migrations.CreatePortfolios do
  use Ecto.Migration

  def change do
    create table(:portfolios) do
      add :stocks, :map
      add :investment, :float
      add :current_value, :float
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:portfolios, [:user_id])
  end
end
