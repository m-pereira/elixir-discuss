defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Blog.Topic
  alias Discuss.Blog

  plug(DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete])
  plug :check_topic_owner when action in [:edit, :update, :delete]

  action_fallback(DiscussWeb.FallbackController)

  def index(conn, _params) do
    topics = Blog.list_topics()

    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    topic_params = topic_params |> Map.merge(%{"user_id" => conn.assigns.user.id})

    with {:ok, _topic} <- Blog.create_topic(topic_params) do
      conn
      |> put_flash(:info, "Topic created")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def show(conn, %{"id" => id}) do
    topic = Blog.get_topic!(id)

    render(conn, "show.html", topic: topic)
  end

  def edit(conn, %{"id" => id}) do
    topic = Blog.get_topic!(id)
    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, id: id)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    with topic <- Blog.get_topic!(id), {:ok, _topic} <- Blog.update_topic(topic, topic_params) do
      conn
      |> put_flash(:info, "Topic updated")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  def delete(conn, %{"id" => id}) do
    with topic <- Blog.get_topic!(id), {:ok, _topic} <- Blog.delete_topic(topic) do
      conn
      |> put_flash(:info, "Topic was successfully deleted")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
  end

  # these params are not the same of action params
  defp check_topic_owner(conn, _params) do
    %{params: %{"id" => topic_id}} = conn
    current_user = conn.assigns.user

    with topic <- Blog.get_topic!(topic_id) do
      case topic.user_id == current_user.id do
        true -> conn
        _ -> halt_with_message(conn, "You are not the owner of this topic")
      end
    end
  rescue
    _e in Ecto.NoResultsError -> halt_with_message(conn, "Topic not found")
  end

  defp halt_with_message(conn, message) do
    conn
    |> put_flash(:error, message)
    |> redirect(to: Routes.topic_path(conn, :index))
    |> halt()
  end
end
