defmodule Discuss.Plugs.CurrentUser do
  import Plug.Conn

  alias Discuss.Auth

  def init(_params) do
  end

  # here the params will be the return of init method
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Auth.get_user!(user_id) ->
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
