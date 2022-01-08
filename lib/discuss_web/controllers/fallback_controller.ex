defmodule Discuss.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(MyErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> put_view(MyErrorView)
    |> render(:"403")
  end

  def call(conn, {:error, changeset}) do
    conn
    |> put_status(422)
    |> put_view(DiscussWeb.TopicView)
    |> render("new.html", changeset: changeset)
  end
end
