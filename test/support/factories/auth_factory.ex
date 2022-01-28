defmodule Discuss.AuthFactory do
  use ExMachina.Ecto, repo: Discuss.Repo

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Discuss.Auth.User{
          email: sequence(:email, &"email-#{&1}@example.com"),
          provider: "github",
          token: sequence(:token, &"gho_RI1qDgAQL2V6s4zqAPjH60A7#{&1}")
        }
      end
    end
  end
end
