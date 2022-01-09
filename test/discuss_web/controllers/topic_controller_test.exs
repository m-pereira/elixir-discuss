defmodule Discuss.TopicControllerTest do
  use DiscussWeb.ConnCase

  import Discuss.BlogFixtures

  @create_attrs %{title: "some title"}
  @update_attrs %{title: "some other title"}
  @invalid_attrs %{title: nil}

  describe "GET /" do
    test "returns http status 200, and renders the index template", %{conn: conn} do
      conn = get(conn, "/")

      assert conn.status == 200
      assert conn.resp_body =~ "Topics"
    end
  end

  describe "GET /new" do
    test "returns http status 200, and renders the new template", %{conn: conn} do
      conn = conn |> get(Routes.topic_path(conn, :new))

      assert conn.status == 200
      assert conn.resp_body =~ "Create a new Topic"
    end
  end

  describe "GET /edit" do
    test "returns http status 200, and renders the edit template", %{conn: conn} do
      topic = topic_fixture(@create_attrs)
      conn = get(conn, Routes.topic_path(conn, :edit, topic.id))

      assert conn.status == 200
      assert conn.resp_body =~ "Edit Topic"
    end
  end

  describe "POST /create" do
    test "does not create a new topic and renders the new form, when failure", %{conn: conn} do
      conn = post(conn, Routes.topic_path(conn, :create), %{"topic" => @invalid_attrs})

      assert html_response(conn, 200) =~ "Create a new Topic"
    end

    test "creates the Topic and redirects to root_path when success", %{conn: conn} do
      conn = post(conn, Routes.topic_path(conn, :create), %{"topic" => @create_attrs})

      assert redirected_to(conn) == Routes.topic_path(conn, :index)

      conn = get(conn, Routes.topic_path(conn, :index))

      assert conn.resp_body =~ "some title"
    end
  end

  describe "PUT /update" do
    setup do
      topic = topic_fixture(@create_attrs)

      {:ok, topic: topic}
    end

    test "updates the topic and redirects to index page", %{conn: conn, topic: topic} do
      conn =
        put conn,
            Routes.topic_path(conn, :update, topic.id),
            %{"topic" => @update_attrs}

      assert redirected_to(conn) == Routes.topic_path(conn, :index)

      conn = get(conn, Routes.topic_path(conn, :index))

      assert conn.resp_body =~ "some other title"
    end

    test "does not update the topic and renders the edit form, when failure",
         %{conn: conn, topic: topic} do
      conn =
        put conn,
            Routes.topic_path(conn, :update, topic.id),
            %{"topic" => @invalid_attrs}

      assert html_response(conn, 200) =~ "Edit Topic"
    end
  end

  describe "DELETE /delete" do
    test "deletes the topic and redirects to index page", %{conn: conn} do
      topic = topic_fixture(@create_attrs)
      conn = delete(conn, Routes.topic_path(conn, :delete, topic.id))

      assert redirected_to(conn) == Routes.topic_path(conn, :index)

      conn = get(conn, Routes.topic_path(conn, :index))

      refute conn.resp_body =~ "some title"
    end
  end
end
