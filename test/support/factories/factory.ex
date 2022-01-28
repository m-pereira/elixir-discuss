defmodule Discuss.Factory do
  use ExMachina.Ecto, repo: Discuss.Repo

  def topic_factory do
    %Discuss.Blog.Topic{
      title: sequence(:title, &"This is a topic number: #{&1}"),
      user: build(:user)
    }
  end

  def user_factory do
    %Discuss.Auth.User{
      email: sequence(:email, &"email-#{&1}@example.com"),
      provider: "github",
      token: sequence(:token, &"gho_RI1qDgAQL2V6s4zqAPjH60A7#{&1}")
    }
  end
end
