defmodule Discuss.TopicControllerTest do
  use DiscussWeb.ConnCase

  @create_attrs %{title: "some title"}
  @invalid_attrs %{title: nil}

  describe "GET /" do
    test "returns http status 200, and renders the index template" do
      conn = get(build_conn(), "/")

      assert conn.status == 200
      assert conn.resp_body =~ "Topics"
    end
  end

  describe "GET /new" do
    test "returns http status 200, and renders the new template" do
      conn = build_conn()
      conn = conn |> get(Routes.topic_path(conn, :new))

      assert conn.status == 200
      assert conn.resp_body =~ "Create a new Topic"
    end
  end

  describe "POST /create" do
    test "does not create a new topic and renders the new form, when failure" do
      conn = build_conn()
      conn = conn |> post(Routes.topic_path(conn, :create), %{"topic" => @invalid_attrs})

      assert html_response(conn, 200) =~ "Create a new Topic"
    end

    test "creates the Topic and redirects to root_path when success" do
      conn = build_conn()
      conn = conn |> post(Routes.topic_path(conn, :create), %{"topic" => @create_attrs})

      assert redirected_to(conn) == Routes.topic_path(conn, :index)

      conn = conn |> get(Routes.topic_path(conn, :index))

      assert conn.resp_body =~ "some title"
    end
  end
end
