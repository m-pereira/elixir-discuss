defmodule Discuss.Auth.User do
  use Ecto.Schema
  import Ecto.Changeset

  @type t :: %__MODULE__{
          email: String.t(),
          provider: String.t(),
          token: String.t()
        }

  @required_fields [:email, :provider, :token]

  schema "users" do
    field :email, :string
    field :provider, Ecto.Enum, values: [:github]
    field :token, :string

    has_many :topics, Discuss.Blog.Topic
    has_many :comments, Discuss.Blog.Comment

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:provider, [:github])
    |> unique_constraint(:email)
  end
end
