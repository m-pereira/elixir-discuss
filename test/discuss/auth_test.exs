defmodule Discuss.AuthTest do
  use Discuss.DataCase

  alias Discuss.Auth

  describe "users" do
    alias Discuss.Auth.User

    import Discuss.AuthFixtures

    @valid_attrs %{email: "john@email.com", provider: "github", token: "some token"}
    @invalid_attrs %{email: nil, provider: nil, token: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Auth.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{email: "some email", provider: "github", token: "some token"}

      assert {:ok, %User{} = user} = Auth.create_user(valid_attrs)
      assert user.email == "some email"
      assert user.provider == :github
      assert user.token == "some token"
    end

    test "enum provider, when invalid value" do
      changeset = User.changeset(%User{}, %{@valid_attrs | provider: "invalid"})

      refute changeset.valid?
    end

    test "enum provider, when valid value" do
      changeset = User.changeset(%User{}, @valid_attrs)

      assert changeset.valid?
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Auth.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        email: "some updated email",
        token: "some updated token"
      }

      assert {:ok, %User{} = user} = Auth.update_user(user, update_attrs)
      assert user.email == "some updated email"
      assert user.provider == :github
      assert user.token == "some updated token"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end
  end
end
