defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.{Blog, Repo, EctoHelper}

  @impl true
  @spec join(String.t(), any, Phoenix.Socket.t()) ::
          {:ok, %{comments: any}, Phoenix.Socket.t()}
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Blog.get_topic!(topic_id) |> Repo.preload(comments: :user)
    socket = socket |> assign(:topic, topic)

    {:ok, %{comments: topic.comments}, socket}
  end

  @impl true
  @spec handle_in(String.t(), %{String.t() => String.t()}, Phoenix.Socket.t()) ::
          {:reply, :ok, Phoenix.Socket.t()}
          | {:reply, {:error, %{errors: [String.t()]}}, Phoenix.Socket.t()}
  def handle_in("comment:add", %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset =
      topic
      |> Ecto.build_assoc(:comments, %{user_id: user_id})
      |> Blog.Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket, "comments:#{socket.assigns.topic.id}:new", %{
          comment: Repo.preload(comment, :user)
        })

        {:reply, :ok, socket}

      {:error, _changeset} ->
        {:reply, {:error, %{errors: EctoHelper.pretty_errors(changeset.errors)}}, socket}
    end
  end

  @impl true
  def handle_in("comment:destroy", %{"commentId" => comment_id}, socket) do
    with comment <- Blog.get_comment!(comment_id) do
      case Blog.delete_comment(comment) do
        {:ok, comment} ->
          broadcast!(socket, "comments:#{socket.assigns.topic.id}:destroy", %{
            comment: Repo.preload(comment, :user)
          })

          {:reply, :ok, socket}

        {:error, changeset} ->
          {:reply, {:error, %{errors: EctoHelper.pretty_errors(changeset.errors)}}, socket}
      end
    end
  end
end
