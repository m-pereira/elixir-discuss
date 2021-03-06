defmodule Discuss.Blog.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :title, :string

    belongs_to :user, Discuss.Auth.User

    has_many :comments, Discuss.Blog.Comment

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = topic, attrs \\ %{}) do
    topic
    |> cast(attrs, [:title, :user_id])
    |> validate_required([:title, :user_id])
  end
end
