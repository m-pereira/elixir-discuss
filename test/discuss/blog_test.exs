defmodule Discuss.BlogTest do
  use Discuss.DataCase, async: true

  import Discuss.Factories

  alias Discuss.Blog

  describe "topics" do
    alias Discuss.Blog.Topic

    @invalid_attrs %{title: nil}
    @valid_attrs %{title: "Some title"}

    test "list_topics/0 returns all topics ordered by title" do
      %Topic{id: first_topic_id} = insert(:topic)
      %Topic{id: second_topic_id} = insert(:topic)

      assert [%Topic{id: ^first_topic_id}, %Topic{id: ^second_topic_id}] = Blog.list_topics()
    end

    test "get_topic!/1 returns the topic with given id" do
      %Topic{id: topic_id} = insert(:topic, @valid_attrs)

      assert %Topic{id: ^topic_id} = Blog.get_topic!(topic_id)
    end

    test "create_topic/1 with valid data, creates a topic" do
      current_user = insert(:user)
      valid_attrs = Map.merge(@valid_attrs, %{user_id: current_user.id})

      assert {:ok, %Topic{} = _topic} = Blog.create_topic(valid_attrs)
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = insert(:topic, @valid_attrs)
      update_attrs = %{title: "Another title"}

      assert {:ok, %Topic{} = _topic} = Blog.update_topic(topic, update_attrs)
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = insert(:topic, @valid_attrs)

      assert {:error, %Ecto.Changeset{}} = Blog.update_topic(topic, @invalid_attrs)
      refute Blog.get_topic!(topic.id).title == @invalid_attrs[:title]
    end

    test "delete_topic/1 deletes the topic" do
      topic = insert(:topic, @valid_attrs)

      assert {:ok, %Topic{}} = Blog.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = insert(:topic, @valid_attrs)

      assert %Ecto.Changeset{} = Blog.change_topic(topic)
    end
  end
end
