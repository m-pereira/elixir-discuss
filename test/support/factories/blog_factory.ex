defmodule Discuss.BlogFactory do
  use ExMachina.Ecto, repo: Discuss.Repo

  def topic_factory do
    %Discuss.Blog.Topic{title: sequence(:title, &"This is a topic number: #{&1}")}
  end
end
