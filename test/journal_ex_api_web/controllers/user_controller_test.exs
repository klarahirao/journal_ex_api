defmodule JournalExApiWeb.UserControllerTest do
  use JournalExApiWeb.ConnCase

  alias JournalExApi.Accounts
  alias JournalExApi.Journals
  import JournalExApi.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "sign_up" do
    @sign_up_attrs %{
      age: 55,
      first_name: "Rick",
      last_name: "Sanchez",
      username: "rickk",
      password: "password"
    }

    test "signs up when data is valid", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :sign_up), @sign_up_attrs)
        |> json_response(201)

      {:ok, user} = Accounts.get_user_by_username("rickk")
      {:ok, author} = Journals.author_for_user(user)
      token = response["data"]["attributes"]["token"]

      assert Bcrypt.check_pass("password", user.encrypted_password)
      assert author.first_name == "Rick"
      assert author.last_name == "Sanchez"
      assert author.age == 55
      assert {:ok, _claims} = JournalExApiWeb.Auth.Guardian.decode_and_verify(token)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      response =
        conn
        |> post(Routes.user_path(conn, :sign_up), %{username: "rickk"})
        |> json_response(422)

      assert response["errors"] == %{"password" => ["can't be blank"]}
    end
  end

  describe "sign_in" do
    @sign_in_attrs %{
      username: "rickk",
      password: "password"
    }

    test "signs in when data is valid", %{conn: conn} do
      user =
        insert(:user,
          username: "rickk",
          password: "password",
          encrypted_password: Bcrypt.hash_pwd_salt("password")
        )

      insert(:author, user_id: user.id)

      response =
        conn
        |> post(Routes.user_path(conn, :sign_in), @sign_in_attrs)
        |> json_response(201)

      token = response["data"]["attributes"]["token"]
      assert {:ok, _claims} = JournalExApiWeb.Auth.Guardian.decode_and_verify(token)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user =
        insert(:user,
          username: "rickk",
          password: "password",
          encrypted_password: Bcrypt.hash_pwd_salt("password")
        )

      insert(:author, user_id: user.id)

      response =
        conn
        |> post(Routes.user_path(conn, :sign_in), %{username: "rickk", password: "invalid"})
        |> json_response(401)

      assert response["errors"] != %{}
    end
  end
end
