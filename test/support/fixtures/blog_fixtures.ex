defmodule Discuss.BlogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Discuss.Blog` context.
  """

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{})
      |> Discuss.Blog.create_topic()

    topic
  end
end
