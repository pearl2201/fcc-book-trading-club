defmodule BookTrading.PasswordAccount do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias BookTrading.Repo
  alias Bcrypt
  alias BookTrading.Account.User
  alias BookTrading.Account.PasswordMember

  def authenticate_user(username, plain_text_password) do
    query = from u in User, where: u.username == ^username,preload: [:password_member]

    case Repo.one(query) do
      nil ->
        {:error, :username_doesnt_exists}

      user ->


        if Bcrypt.verify_pass(plain_text_password, user.password_member.hashed_password) do
          {:ok, user}
        else
          {:error, :invalid_credentials}
        end
    end
  end

  @doc """
  Find or create user with oauth
  """
  def create(
        %{
          "username" => username,
          "email" => email
        } = attrs
      ) do
    query = from u in User, where: u.email == ^email or u.username == ^username, select: u

    case Repo.one(query) do
      nil ->
        IO.puts("no password member found")

        {:ok, user} =
          %User{}
          |> User.changeset(attrs)
          |> Repo.insert()

        {:ok, _} =
          %PasswordMember{}
          |> PasswordMember.changeset(Map.put(attrs, "user_id", user.id))
          |> Repo.insert()

        {:ok, user}

      _ ->
        {:error, :username_or_email_exists}
    end
  end
end
