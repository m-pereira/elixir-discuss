defmodule Discuss.Blog.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields [:content, :user_id, :topic_id]

  @derive {Jason.Encoder, only: [:id, :content, :user]}

  schema "comments" do
    field :content, :string

    belongs_to :user, Discuss.Auth.User
    belongs_to :topic, Discuss.Blog.Topic

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = comment, attrs) do
    comment
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
