defmodule BookTrading.Account.PasswordMember do
  use Ecto.Schema
  alias Bcrypt
  import Ecto.Changeset

  schema "password_member" do
    field :hashed_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    belongs_to :user, BookTrading.Account.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :password_confirmation, :user_id])
    |> validate_required([:password, :password_confirmation, :user_id])
    |> validate_confirmation(:password)
    |> put_pass_hash
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    hash = Bcrypt.hash_pwd_salt(password)
    change(changeset, hashed_password: hash)
  end

  defp put_pass_hash(changeset), do: changeset
end
