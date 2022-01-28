defmodule Discuss.Blog.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string

    belongs_to :user, Discuss.Auth.User

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
