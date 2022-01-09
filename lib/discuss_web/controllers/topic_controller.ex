defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Blog.Topic
  alias Discuss.Blog

  action_fallback Discuss.FallbackController

  def index(conn, _params) do
    topics = Blog.list_topics()

    render(conn, "index.html", topics: topics)
  end

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic_params}) do
    # to make this way work, we need to create a FallbackController like described here:
    # https://hexdocs.pm/phoenix/Phoenix.Controller.html
    # with {:ok, _topic} <- Repo.insert(changeset) do
    #   redirect(conn, to: Routes.topic_path(conn, :index), notice: "Topic created")
    # end

    case Blog.create_topic(topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    topic = Blog.get_topic!(id)

    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, id: id)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Blog.get_topic!(id)

    case Blog.update_topic(topic, topic_params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset, id: id)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Blog.get_topic!(id)

    Blog.delete_topic(topic)

    conn
    |> put_flash(:info, "Topic deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
