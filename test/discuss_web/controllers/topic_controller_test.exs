defmodule Discuss.TopicControllerTest do
  use DiscussWeb.ConnCase

  describe "GET /new" do
    test "returns http status 200, and renders the new template" do
      conn = get(build_conn(), "/topics/new")

      assert conn.status == 200
      assert conn.resp_body =~ "Create a new Topic"
    end
  end
end
