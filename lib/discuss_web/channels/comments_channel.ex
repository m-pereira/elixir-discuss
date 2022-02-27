defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.{Blog, Repo, EctoHelper}

  @impl true
  def join("comments:" <> topic_id, %{"userId" => user_id}, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Blog.get_topic!(topic_id) |> Repo.preload(comments: :user)
    socket = socket |> assign(:topic, topic) |> assign(:user_id, user_id)

    {:ok, %{comments: topic.comments}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("comment:add", %{"content" => content}, socket) do
    topic = socket.assigns.topic
    user_id = socket.assigns.user_id

    changeset =
      topic
      |> Ecto.build_assoc(:comments, %{user_id: user_id})
      |> Blog.Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        {:reply, :ok, socket}

      {:error, _error} ->
        {:reply, {:error, %{errors: EctoHelper.pretty_errors(changeset.errors)}}, socket}
    end
  end

  @impl true
  def handle_in("delete_comment", %{"commentId" => comment_id}, socket) do
    with comment <- Blog.get_comment!(comment_id) do
      case Blog.delete_comment(comment) do
        {:ok, _comment} ->
          {:reply, :ok, socket}

        {:error, changeset} ->
          {:reply, {:error, %{errors: EctoHelper.pretty_errors(changeset.errors)}}, socket}
      end
    end
  end
end
