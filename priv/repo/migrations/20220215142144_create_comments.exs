defmodule Discuss.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :content, :string
      add :user_id, references(:users, dependent: :delete_all)
      add :topic_id, references(:topics, dependent: :delete_all)

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:topic_id])
  end
end
