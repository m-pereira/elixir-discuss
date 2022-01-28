defmodule DiscussWeb.Plugs.RequireAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias DiscussWeb.Router.Helpers, as: Routes

  def init(_params) do
  end

  def call(conn, _params) do
    cond do
      conn.assigns[:user] != nil ->
        conn

      true ->
        conn
        |> put_flash(:error, "You must be logged in")
        |> redirect(to: Routes.topic_path(conn, :index))
        # interrupt the processing of this connection, do not call the next plug
        |> halt()
    end
  end
end
