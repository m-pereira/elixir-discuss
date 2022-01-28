defmodule DiscussWeb.AuthControllerTest do
  use DiscussWeb.ConnCase, async: true

  import Discuss.Factories

  setup %{conn: conn} do
    user = insert(:user, %{email: "john.doe@example.com"})

    auth = %Ueberauth.Auth{
      provider: :github,
      info: %{email: user.email},
      credentials: %{token: "1235"}
    }

    conn = conn |> assign(:ueberauth_auth, auth) |> assign(:user, user)

    {:ok, conn: conn, user: user, auth: auth}
  end

  describe "GET /:provider/callback" do
    test "create or update the user, signs user in, and redirect to topics index", %{
      conn: conn,
      user: user
    } do
      conn = conn |> get("/auth/github/callback")

      assert get_flash(conn, :info) == "Successfully signed in with github"
      assert get_session(conn, :user_id) == user.id
      assert redirected_to(conn) == Routes.topic_path(conn, :index)
    end

    test "when invalid params, redirects to topics index, and has flash error", %{conn: conn} do
      auth = %Ueberauth.Auth{
        provider: :github,
        info: %{email: ""},
        credentials: %{token: ""}
      }

      conn =
        conn
        |> assign(:ueberauth_auth, auth)
        |> get("/auth/github/callback")

      assert get_flash(conn, :error) == ["Email can't be blank", "Token can't be blank"]
      assert get_session(conn, :user_id) == nil
      assert redirected_to(conn) == Routes.topic_path(conn, :index)
    end
  end

  describe "GET /logout" do
    test "destroy the session and redirect to topics path", %{conn: conn, user: user} do
      assert conn.assigns[:user] == user

      conn = conn |> get("/auth/logout")

      assert get_session(conn, :user_id) == nil
      assert conn.assigns[:user] == nil
    end
  end
end
