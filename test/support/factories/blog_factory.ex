defmodule Discuss.BlogFactory do
  use ExMachina.Ecto, repo: Discuss.Repo

  defmacro __using__(_opts) do
    quote do
      def topic_factory do
        %Discuss.Blog.Topic{
          title: sequence(:title, &"This is a topic number: #{&1}"),
          user: build(:user)
        }
      end
    end
  end
end
