defmodule DiscussWeb.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(DiscussWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(DiscussWeb.ErrorView)
    |> render(:"403")
  end

  def call(conn, {:error, changeset}) do
    options = [changeset: changeset, id: conn.params["id"]]

    conn
    |> put_status(422)
    |> put_view(view_from(conn))
    |> render(action_from(conn), options)
  end

  defp view_from(conn) do
    conn.private.phoenix_view
  end

  defp action_from(conn) do
    case conn.private.phoenix_action do
      :create -> "new.html"
      :update -> "edit.html"
      _ -> raise "Unknown action: #{conn.private.phoenix_action}"
    end
  end
end
