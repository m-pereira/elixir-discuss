defmodule Discuss.Auth do
  @moduledoc """
  The Auth context.
  """

  import Ecto.Query, warn: false
  alias Discuss.Repo

  alias Discuss.Auth.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
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
  def get_user!(id), do: Repo.get!(User, id)

  @spec get_user_by(keyword()) :: User.t() | nil
  @doc """
  Finds a user by the given attribute.

  ## Examples

      iex> get_user_by(email: "some_user@email.com")
      %User{}

      iex> get_user_by(email: "other@email.com")
      nil

  """
  def get_user_by(clauses), do: Repo.get_by(User, clauses)

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
  Deletes a user.

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
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @spec upsert(map) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  @doc """
  Check if a user is already into the database with given email. If yes, update token and provider.
  If not, create a new user.

  ## Examples

      iex> perform(%{email: "john@email.com", provider: "github", token: "123456789"})
      {:ok, %Auth.User{}}

      iex> perform(%{email: "john@email.com", provider: "invalid", token: nil})
      {:error, %Auth.User.changeset{}}
  """
  def upsert(params) do
    case get_user_by(email: params.email) do
      nil -> create_user(params)
      user -> update_user(user, params)
    end
  end
end
