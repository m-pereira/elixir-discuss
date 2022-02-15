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

      assert {:error, changeset} = Blog.update_topic(topic, @invalid_attrs)
      assert changeset.errors == [title: {"can't be blank", [validation: :required]}]
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

  describe "comments" do
    alias Discuss.Blog.Comment

    @invalid_attrs %{content: nil}

    test "list_comments/0 returns all comments" do
      %Comment{id: first_comment_id} = insert(:comment)
      %Comment{id: second_comment_id} = insert(:comment)

      assert [%Comment{id: ^first_comment_id}, %Comment{id: ^second_comment_id}] =
               Blog.list_comments()
    end

    test "get_comment!/1 returns the comment with given id" do
      %Comment{id: comment_id} = insert(:comment)

      assert %Comment{id: ^comment_id} = Blog.get_comment!(comment_id)
    end

    test "create_comment/1 with valid data creates a comment" do
      current_user = insert(:user)
      topic = insert(:topic, %{user: current_user})
      valid_attrs = %{content: "some content", topic_id: topic.id, user_id: current_user.id}

      assert {:ok, %Comment{} = comment} = Blog.create_comment(valid_attrs)
      assert comment.content == "some content"
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blog.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = insert(:comment)
      update_attrs = %{content: "some updated content"}

      assert {:ok, %Comment{} = comment} = Blog.update_comment(comment, update_attrs)
      assert comment.content == "some updated content"
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = insert(:comment)

      assert {:error, changeset} = Blog.update_comment(comment, @invalid_attrs)
      assert changeset.errors == [content: {"can't be blank", [validation: :required]}]
      refute Blog.get_comment!(comment.id).content == @invalid_attrs[:content]
    end

    test "delete_comment/1 deletes the comment" do
      comment = insert(:comment)

      assert {:ok, %Comment{}} = Blog.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Blog.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = insert(:comment)

      assert %Ecto.Changeset{} = Blog.change_comment(comment)
    end
  end
end
