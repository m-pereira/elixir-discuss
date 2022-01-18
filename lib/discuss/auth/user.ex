defmodule Discuss.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:email, :provider, :token]

  schema "users" do
    field :email, :string
    field :provider, Ecto.Enum, values: [:github]
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:email)
  end
end
