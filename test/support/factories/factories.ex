defmodule Discuss.Factories do
  @moduledoc false

  use ExMachina.Ecto, repo: Discuss.Repo
  use Discuss.BlogFactory
  use Discuss.AuthFactory
end
