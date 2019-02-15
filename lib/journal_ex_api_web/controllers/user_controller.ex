defmodule JournalExApiWeb.UserController do
  use JournalExApiWeb, :controller

  alias JournalExApi.Accounts
  alias JournalExApi.Journals
  alias JournalExApiWeb.Auth.Guardian

  action_fallback JournalExApiWeb.FallbackController

  def sign_up(conn, params) do
    with {user_params, author_params} <- Map.split(params, ["username", "password"]),
         {:ok, %Accounts.User{} = user} <- Accounts.create_user(user_params),
         {:ok, %Journals.Author{}} <- Journals.create_author(user, author_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user.id) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(username, password) do
      conn
      |> put_status(:created)
      |> render("user.json", %{user: user, token: token})
    end
  end
end
