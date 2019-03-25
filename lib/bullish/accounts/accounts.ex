defmodule Bullish.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Bullish.Repo

  alias Bullish.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user(auth_id) do
    query = Ecto.Query.from(u in User, where: u.auth_id == ^auth_id)
    Repo.one(query)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id) do
    Repo.get!(User, id)
    |> Repo.preload(:portfolios)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  ## Use auth0 callback to create a user ##
  def find_or_add(attrs = %{id: id, avatar: avatar, name: name}) do
    case get_user(id) do
      %User{auth_id: id} -> IO.puts("***~~~ User exists in DB ~~~***")
      _ -> User.changeset(%User{auth_id: id, avatar: avatar, name: name}, attrs) |> Repo.insert()
    end
  end

  # defp check_for_user(id) do
  # user =
  #   from(u in User)
  #   |> where([u], u.auth_id == ^id)
  #   |> Repo.one()
  # end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
