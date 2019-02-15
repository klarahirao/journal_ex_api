defmodule JournalExApi.AccountsTest do
  use JournalExApi.DataCase

  alias JournalExApi.Accounts

  describe "users" do
    @valid_attrs %{password: "password", username: "morty_c137"}

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %Accounts.User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.username == "morty_c137"
      assert Bcrypt.verify_pass("password", user.encrypted_password)
    end

    test "create_user/1 with exisitng username returns error changeset" do
      Accounts.create_user(@valid_attrs)
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(@valid_attrs)
    end

    test "create_user/1 with too short password returns error changeset" do
      attrs = %{password: "p", username: "morty_c137"}

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(attrs)
    end

    test "create_user/1 with missing data returns error changeset" do
      attrs = %{password: nil, username: nil}

      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(attrs)
    end
  end
end
