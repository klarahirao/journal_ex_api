defmodule JournalExApi.Factory do
  @moduledoc """
  Holds factories.
  """

  alias JournalExApi.Repo
  alias JournalExApi.Accounts
  alias JournalExApi.Journals

  use ExMachina.Ecto, repo: Repo

  def user_factory do
    %Accounts.User{
      username: sequence(:username, &"john_#{&1}"),
      password: "password",
      encrypted_password: Bcrypt.hash_pwd_salt("password")
    }
  end

  def author_factory do
    %Journals.Author{
      age: 25,
      first_name: sequence(:first_name, &"John #{&1}"),
      last_name: sequence(:last_name, &"Doe #{&1}"),
      user_id: insert(:user).id
    }
  end

  def article_factory do
    %Journals.Article{
      title: sequence(:title, &"Lorem Ipsum #{&1}"),
      body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
      published_date: DateTime.utc_now(),
      author: build(:author)
    }
  end
end
