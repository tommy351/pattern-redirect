defmodule PatternRedirect.User do
  use PatternRedirect.Web, :model
  import Comeonin.Bcrypt

  schema "users" do
    field :name, :string
    field :email, :string
    field :password, :string

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email, name: :users_lower_email_index)
    |> validate_length(:password, min: 6, max: 30)
    |> update_change(:password, &hashpwsalt/1)
  end
end