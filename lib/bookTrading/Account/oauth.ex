defmodule BookTrading.Account.OAuthMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "oauth_member" do
    field :provider, :string
    field :provider_user_id, :string
    belongs_to :user, BookTrading.Account.User

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:provider, :provider_user_id, ])
    |> validate_required([:provider, :provider_user_id, ])
  end

end
