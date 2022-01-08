defmodule Discuss.BlogTest do
  use Discuss.DataCase

  alias Discuss.Blog

  describe "topics" do
    alias Discuss.Blog.Topic

    import Discuss.BlogFixtures

    @invalid_attrs %{title: nil}
    @valid_attrs %{title: "Some title"}

    test "list_topics/0 returns all topics" do
      topic = topic_fixture(@valid_attrs)

      assert Blog.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture(@valid_attrs)

      assert Blog.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = _topic} = Blog.create_topic(@valid_attrs)
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture(@valid_attrs)
      update_attrs = %{title: "Another title"}

      assert {:ok, %Topic{} = _topic} = Blog.update_topic(topic, update_attrs)
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture(@valid_attrs)

      assert {:error, %Ecto.Changeset{}} = Blog.update_topic(topic, @invalid_attrs)
      assert topic == Blog.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture(@valid_attrs)

      assert {:ok, %Topic{}} = Blog.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture(@valid_attrs)

      assert %Ecto.Changeset{} = Blog.change_topic(topic)
    end
  end
end
