defmodule Discuss.AuthController do
  use DiscussWeb, :controller

  alias Discuss.EctoHelper
  alias Discuss.Auth

  plug Ueberauth

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    user_params = %{
      token: auth.credentials.token,
      email: auth.info.email,
      provider: auth.provider
    }

    case Auth.upsert(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully signed in with #{auth.provider}")
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, changeset} ->
        conn
        |> put_flash(:error, EctoHelper.pretty_errors(changeset.errors))
        |> redirect(to: Routes.topic_path(conn, :index))
    end
  end
end
