defmodule BookTrading.OAuthAccount do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  require Logger
  require Poison



  alias BookTrading.Repo
  alias Bcrypt
  alias BookTrading.Account.User
  alias BookTrading.Account.OAuthMember
  alias Ueberauth.Auth

  @doc """
  Create user
  """
  def find_or_create(%Auth{} = auth) do
    query =
      from u in OAuthMember,
        where: u.provider == ^Atom.to_string(auth.provider) and u.provider_user_id == ^auth.uid

    case Repo.one(query) do
      nil ->
        IO.puts("no oath member found")

        case Repo.get_by(User, email: auth.info.email) do
          nil ->
            {:ok, user} = %User{username: auth.info.name, email: auth.info.email, avatar_url: auth.info.image} |> Repo.insert()

            oauthMember =
              Ecto.build_assoc(user, :oauth_member, %{
                provider: Atom.to_string(auth.provider),
                provider_user_id: auth.uid
              })

            Repo.insert!(oauthMember)
            {:ok, user}

          user ->
            oauthMember =
              Ecto.build_assoc(user, :oauth_member, %{
                provider: Atom.to_string(auth.provider),
                provider_user_id: auth.uid
              })

            Repo.insert!(oauthMember)
            {:ok, user}
        end

      oauthMember ->
        case Repo.get!(User, oauthMember.user_id) do
          nil ->
            {
              :error,
              :invalid_credentials
            }

          user ->
            {:ok, user}
        end
    end
  end

end
