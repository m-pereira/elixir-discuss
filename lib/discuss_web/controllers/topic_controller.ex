defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Blog.Topic
  alias Discuss.Blog

  action_fallback DiscussWeb.FallbackController

  def index(conn, _params) do
    topics = Blog.list_topics()

    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    with {:ok, _topic} <- Blog.create_topic(topic_params) do
      conn
      |> put_flash(:info, "Topic created")
      |> redirect(to: Routes.topic_path(conn, :index))
    end
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
end
