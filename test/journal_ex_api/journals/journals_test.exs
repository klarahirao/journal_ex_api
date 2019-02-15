defmodule JournalExApi.JournalsTest do
  use JournalExApi.DataCase
  import JournalExApi.Factory

  alias JournalExApi.Journals

  describe "articles" do
    alias JournalExApi.Journals.Article

    test "list_articles/1 returns all articles" do
      now1 = DateTime.utc_now() |> DateTime.truncate(:second)
      now2 = DateTime.utc_now() |> DateTime.add(10) |> DateTime.truncate(:second)

      article1 = insert(:article, published_date: now1)
      article2 = insert(:article, published_date: now2)

      assert Journals.list_articles().entries == [article2, article1]
    end

    test "get_article/1 returns all articles" do
      article = insert(:article)
      {:ok, expected_article} = Journals.get_article(article.id)

      assert expected_article.id == article.id
    end

    test "create_article/2 with valid data creates an article" do
      author = insert(:author)

      attrs = %{
        title: "Lorem Ipsum",
        body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        description: "Lorem ipsum dolor sit amet"
      }

      assert {:ok, %Article{} = article} = Journals.create_article(author, attrs)
      assert article.title == attrs[:title]
      assert article.body == attrs[:body]
      assert article.description == attrs[:description]
      assert DateTime.diff(DateTime.utc_now(), article.published_date, :second) < 2
      assert article.author_id == author.id
    end

    test "create_article/2 with missing data returns error changeset" do
      author = insert(:author)

      assert {:error, %Ecto.Changeset{}} = Journals.create_article(author, %{})
    end

    test "create_article/2 with too long title returns error changeset" do
      author = insert(:author)

      attrs = %{
        title: String.duplicate("a", 151),
        body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
        description: "Lorem ipsum dolor sit amet"
      }

      assert {:error, %Ecto.Changeset{}} = Journals.create_article(author, attrs)
    end

    test "delete_article/1 deletes the article" do
      article = insert(:article)

      assert {:ok, %Article{}} = Journals.delete_article(article)
      assert Journals.get_article(article.id) == {:error, :not_found}
    end
  end

  describe "authors" do
    alias JournalExApi.Journals.Author

    @valid_attrs %{age: 55, first_name: "Rick", last_name: "Sanchez"}
    @invalid_attrs %{age: nil, first_name: nil, last_name: nil}

    test "get_author/1 returns the author with given id" do
      author = insert(:author)
      assert Journals.get_author(author.id) == {:ok, author}
    end

    test "create_author/2 with valid data creates a author" do
      user = insert(:user)
      assert {:ok, %Author{} = author} = Journals.create_author(user, @valid_attrs)
      assert author.age == 55
      assert author.first_name == "Rick"
      assert author.last_name == "Sanchez"
      assert author.user_id == user.id
    end

    test "create_author/2 with invalid age returns error changeset" do
      attrs = %{
        age: 1,
        first_name: "Rick",
        last_name: "Sanchez"
      }

      assert {:error, %Ecto.Changeset{}} = Journals.create_author(insert(:user), attrs)
    end

    test "create_author/2 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Journals.create_author(insert(:user), @invalid_attrs)
    end

    test "update_author/2 with valid data updates the author" do
      author =
        insert(:author,
          age: 56,
          first_name: "rickk",
          last_name: "sanchezzz"
        )

      assert {:ok, %Author{} = author} = Journals.update_author(author, @valid_attrs)
      assert author.age == 55
      assert author.first_name == "Rick"
      assert author.last_name == "Sanchez"
    end

    test "update_author/2 with invalid data returns error changeset" do
      author = insert(:author, @valid_attrs)

      assert {:error, %Ecto.Changeset{}} = Journals.update_author(author, @invalid_attrs)
      assert Journals.get_author(author.id) == {:ok, author}
    end
  end
end
