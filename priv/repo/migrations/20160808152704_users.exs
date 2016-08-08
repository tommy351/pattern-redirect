defmodule PatternRedirect.Repo.Migrations.Users do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false, default: ""
      add :email, :string, null: false, default: ""
      add :password, :string, size: 60, null: false

      timestamps
    end

    create index(:users, ["lower(email)"], unique: true)
  end
end
