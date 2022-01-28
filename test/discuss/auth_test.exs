defmodule Discuss.AuthTest do
  use Discuss.DataCase, async: true

  import Discuss.Factories

  alias Discuss.Auth

  describe "users" do
    alias Discuss.Auth.User
    alias Discuss.Auth

    @valid_attrs %{email: "john@email.com", provider: "github", token: "some token"}
    @invalid_attrs %{email: nil, provider: nil, token: nil}

    test "list_users/0 returns all users" do
      user = insert(:user)

      assert Auth.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)
      assert Auth.get_user!(user.id) == user
    end

    test "get_user_by/1 return the user if it exists" do
      user = insert(:user)

      assert Auth.get_user_by(email: user.email) == user
    end

    test "get_user_by/1 returns nil if user does not exist" do
      assert Auth.get_user_by(email: "") == nil
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
      user = insert(:user)

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
      user = insert(:user)
      assert {:error, %Ecto.Changeset{}} = Auth.update_user(user, @invalid_attrs)
      assert user == Auth.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = insert(:user)
      assert {:ok, %User{}} = Auth.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Auth.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)
      assert %Ecto.Changeset{} = Auth.change_user(user)
    end

    test "upsert/1 when successfully with valid attributes, updating user" do
      user = insert(:user, %{token: "old_token"})
      result = Auth.upsert(%{email: user.email, provider: "github", token: "123456-new_token"})

      assert {:ok, %User{provider: :github, token: "123456-new_token"}} = result
    end

    test "upsert/1 when successfully with valid params, creating new user" do
      result = Auth.upsert(%{email: "john@email.com", provider: "github", token: "0"})

      assert {:ok, %User{provider: :github, email: "john@email.com", token: "0"}} = result
    end

    test "upsert/1 when failed with invalid attributes" do
      result = Auth.upsert(%{email: "", provider: "invalid", token: "0"})

      assert {:error, %Ecto.Changeset{}} = result
    end
  end
end
