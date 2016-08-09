defmodule PatternRedirect.Repo.Migrations.Patterns do
  use Ecto.Migration

  def change do
    create table(:patterns) do
      add :rule, :text, null: false, default: ""
      add :target, :text, null: false, default: ""
      add :user_id, references(:users), null: false, on_delete: :delete_all, on_update: :update_all

      timestamps
    end
  end
end
