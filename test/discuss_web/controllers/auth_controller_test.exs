defmodule DiscussWeb.AuthControllerTest do
  use DiscussWeb.ConnCase, async: true

  alias DiscussWeb.AuthController
  alias Discuss.AuthFactory

  describe "GET /:provider/callback" do
    test "create or update the user, signs user in, and redirect to topics index", %{conn: conn} do
      user = AuthFactory.insert(:user, %{email: "john.doe@example.com"})

      auth = %Ueberauth.Auth{
        provider: :github,
        info: %{email: user.email},
        credentials: %{token: "12345"}
      }

      conn =
        conn
        |> bypass_through(DiscussWeb.Router, [:browser])
        |> get("/auth/github/callback")
        |> assign(:ueberauth_auth, auth)
        |> AuthController.callback(%{})

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
        |> bypass_through(DiscussWeb.Router, [:browser])
        |> get("/auth/github/callback")
        |> assign(:ueberauth_auth, auth)
        |> AuthController.callback(%{})

      assert get_flash(conn, :error) == ["Email can't be blank", "Token can't be blank"]
      assert get_session(conn, :user_id) == nil
      assert redirected_to(conn) == Routes.topic_path(conn, :index)
    end
  end

  describe "GET /logout" do
    test "destroy the session and redirect to topics path", %{conn: conn} do
      user = AuthFactory.insert(:user)

      auth = %Ueberauth.Auth{
        provider: :github,
        info: %{email: user.email},
        credentials: %{token: "12345"}
      }

      login_conn =
        conn
        |> bypass_through(DiscussWeb.Router, [:browser])
        |> get("/auth/github/callback")
        |> assign(:ueberauth_auth, auth)
        |> AuthController.callback(%{})

      assert get_session(login_conn, :user_id) == user.id

      logout_conn =
        conn
        |> bypass_through(DiscussWeb.Router, [:browser])
        |> assign(:user, user)
        |> get("/auth/logout")
        |> AuthController.logout(%{})

      assert get_session(logout_conn, :user_id) == nil
    end
  end
end
