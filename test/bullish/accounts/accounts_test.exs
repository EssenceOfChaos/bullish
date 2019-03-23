defmodule Bullish.AccountsTest do
  @moduledoc false
  use Bullish.DataCase

  alias Bullish.Accounts

  describe "users" do
    alias Bullish.Accounts.User

    @valid_attrs %{
      auth_id: "auth|57239390837221",
      avatar: "http://someavatarurl.com/path/to/image",
      display_name: "super cool dude 1995",
      email: "cooldude95@aol.com",
      name: "Franklin",
      play_balance: 42,
      rank: 40,
      watch_list: ["aapl", "tsla"]
    }
    @update_attrs %{
      auth_id: "auth|57239390837222",
      avatar: "http://someavatarurl.com/path/to/new/image",
      display_name: "regular cool dude 1995",
      email: "coolerdude@aol.com",
      name: "BruceWayne",
      play_balance: 43,
      rank: 50,
      watch_list: ["fb", "ibm"]
    }
    @invalid_attrs %{
      auth_id: nil,
      avatar: nil,
      display_name: nil,
      email: nil,
      name: nil,
      play_balance: nil,
      rank: nil,
      watch_list: nil
    }

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
      assert user.auth_id == "auth|57239390837221"
      assert user.avatar == "http://someavatarurl.com/path/to/image"
      assert user.display_name == "super cool dude 1995"
      assert user.email == "cooldude95@aol.com"
      assert user.name == "Franklin"
      assert user.play_balance == 42
      assert user.rank == 40
      assert user.watch_list == ["aapl", "tsla"]
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.auth_id == "auth|57239390837222"
      assert user.avatar == "http://someavatarurl.com/path/to/new/image"
      assert user.display_name == "regular cool dude 1995"
      assert user.email == "coolerdude@aol.com"
      assert user.name == "BruceWayne"
      assert user.play_balance == 43
      assert user.rank == 50
      assert user.watch_list == ["fb", "ibm"]
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
