defmodule DiscussWeb.CommentsChannelTest do
  use DiscussWeb.ChannelCase, async: true

  import Discuss.Factories

  setup do
    user = insert(:user)
    topic = insert(:topic)

    {:ok, _payload, socket} =
      DiscussWeb.UserSocket
      |> socket("comments", %{user_id: user.id})
      |> subscribe_and_join(DiscussWeb.CommentsChannel, "comments:#{topic.id}")

    %{socket: socket, topic: topic}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "comment:add", %{"content" => "some comment content"})

    assert_reply ref, :ok, %{}
  end

  test "shout broadcasts to comment:add", %{socket: socket, topic: topic} do
    push(socket, "comment:add", %{"content" => "some comment content"})
    event = "comments:#{topic.id}:new"

    assert_broadcast ^event, %{comment: %{content: "some comment content"}}
  end

  test "shout broadcasts to comment:destroy", %{socket: socket, topic: topic} do
    comment = insert(:comment, topic: topic, content: "some comment content")
    push(socket, "comment:destroy", %{"commentId" => comment.id})
    event = "comments:#{topic.id}:destroy"

    assert_broadcast ^event, %{comment: %{content: "some comment content"}}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from!(socket, "broadcast", %{"some" => "data"})

    assert_push "broadcast", %{"some" => "data"}
  end
end
