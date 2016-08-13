defmodule PatternRedirect.Repo.Migrations.Pipelines do
  use Ecto.Migration

  def change do
    create table(:pipelines) do
      add :name, :text, null: false, default: ""
      add :user_id, references(:users), null: false, on_delete: :delete_all, on_update: :delete_all

      timestamps
    end

    create table(:pipeline_items) do
      add :pipeline_id, references(:pipelines), null: false, on_delete: :delete_all, on_update: :delete_all
      add :pattern_id, references(:patterns), null: false, on_delete: :delete_all, on_update: :delete_all
      add :index, :integer, null: false, default: 1

      timestamps
    end

    create index(:pipeline_items, [:pipeline_id, :pattern_id], unique: true)
    create index(:pipeline_items, [:index])

    alter table(:patterns) do
      add :name, :text, null: false, default: ""
    end
  end
end
