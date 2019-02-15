defmodule JournalExApiWeb.Auth.Guardian do
  use Guardian, otp_app: :journal_ex_api

  alias JournalExApi.Accounts

  def subject_for_token(user_id, _claims) do
    {:ok, user_id}
  end

  def resource_from_claims(claims) do
    user = Accounts.get_user!(claims["sub"])
    {:ok, user}
  end

  def authenticate(username, password) do
    with {:ok, user} <- Accounts.get_user_by_username(username) do
      case validate_password(password, user.encrypted_password) do
        true ->
          create_token(user)

        false ->
          {:error, :unauthorized}
      end
    end
  end

  defp create_token(user) do
    {:ok, token, _claims} = encode_and_sign(user.id)
    {:ok, user, token}
  end

  defp validate_password(password, encrypted_password) do
    Bcrypt.verify_pass(password, encrypted_password)
  end
end
