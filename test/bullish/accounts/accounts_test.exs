defmodule Bullish.AccountsTest do
  use Bullish.DataCase

  alias Bullish.Accounts

  describe "users" do
    alias Bullish.Accounts.User

    @valid_attrs %{auth_id: "some auth_id", avatar: "some avatar", display_name: "some display_name", email: "some email", name: "some name", play_balance: 42, rank: 42, watch_list: []}
    @update_attrs %{auth_id: "some updated auth_id", avatar: "some updated avatar", display_name: "some updated display_name", email: "some updated email", name: "some updated name", play_balance: 43, rank: 43, watch_list: []}
    @invalid_attrs %{auth_id: nil, avatar: nil, display_name: nil, email: nil, name: nil, play_balance: nil, rank: nil, watch_list: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.auth_id == "some auth_id"
      assert user.avatar == "some avatar"
      assert user.display_name == "some display_name"
      assert user.email == "some email"
      assert user.name == "some name"
      assert user.play_balance == 42
      assert user.rank == 42
      assert user.watch_list == []
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.auth_id == "some updated auth_id"
      assert user.avatar == "some updated avatar"
      assert user.display_name == "some updated display_name"
      assert user.email == "some updated email"
      assert user.name == "some updated name"
      assert user.play_balance == 43
      assert user.rank == 43
      assert user.watch_list == []
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
