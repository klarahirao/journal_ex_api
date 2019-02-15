defmodule JournalExApiWeb.ArticleControllerTest do
  use JournalExApiWeb.ConnCase

  alias JournalExApi.Journals
  alias JournalExApi.Journals.Article
  alias JournalExApiWeb.Auth.Guardian
  alias JournalExApi.Repo
  import JournalExApi.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all articles", %{conn: conn} do
      now1 = DateTime.utc_now() |> DateTime.truncate(:second)
      now2 = DateTime.utc_now() |> DateTime.add(10) |> DateTime.truncate(:second)

      author1 = insert(:author, first_name: "John", last_name: "Doe", age: 25)

      article1 =
        insert(:article,
          author: author1,
          title: "title 1",
          body: "body 1",
          description: "description 1",
          published_date: now1
        )

      author2 = insert(:author, first_name: "Jane", last_name: "Smith", age: 26)

      article2 =
        insert(:article,
          author: author2,
          title: "title 2",
          body: "body 2",
          description: "description 2",
          published_date: now2
        )

      response =
        conn
        |> Guardian.Plug.sign_in(author1.user_id)
        |> get(Routes.article_path(conn, :index), %{page: 1, page_size: 1})
        |> json_response(200)

      assert response == %{
               "data" => [
                 %{
                   "attributes" => %{
                     "body" => "body 2",
                     "description" => "description 2",
                     "published_date" => DateTime.to_iso8601(now2),
                     "title" => "title 2"
                   },
                   "id" => article2.id,
                   "relationships" => %{
                     "author" => %{"data" => %{"id" => author2.id, "type" => "authors"}}
                   },
                   "type" => "articles"
                 }
               ],
               "included" => [
                 %{
                   "attributes" => %{
                     "age" => 26,
                     "first_name" => "Jane",
                     "last_name" => "Smith"
                   },
                   "id" => author2.id,
                   "type" => "authors"
                 }
               ],
               "meta" => %{
                 "page_number" => 1,
                 "page_size" => 1,
                 "total_entries" => 2,
                 "total_pages" => 2
               }
             }

      response =
        conn
        |> Guardian.Plug.sign_in(author1.user_id)
        |> get(Routes.article_path(conn, :index), %{page: 2, page_size: 1})
        |> json_response(200)

      assert response == %{
               "data" => [
                 %{
                   "attributes" => %{
                     "body" => "body 1",
                     "description" => "description 1",
                     "published_date" => DateTime.to_iso8601(now1),
                     "title" => "title 1"
                   },
                   "id" => article1.id,
                   "relationships" => %{
                     "author" => %{"data" => %{"id" => author1.id, "type" => "authors"}}
                   },
                   "type" => "articles"
                 }
               ],
               "included" => [
                 %{
                   "attributes" => %{
                     "age" => 25,
                     "first_name" => "John",
                     "last_name" => "Doe"
                   },
                   "id" => author1.id,
                   "type" => "authors"
                 }
               ],
               "meta" => %{
                 "page_number" => 2,
                 "page_size" => 1,
                 "total_entries" => 2,
                 "total_pages" => 2
               }
             }
    end

    test "respond with 401 when unauthorized", %{conn: conn} do
      conn
      |> get(Routes.article_path(conn, :index))
      |> response(401)
    end
  end

  describe "create article" do
    @create_attrs %{
      article: %{
        body: "body",
        description: "description",
        title: "title"
      }
    }

    test "renders article when data is valid", %{conn: conn} do
      import Ecto.Query

      author = insert(:author)

      response =
        conn
        |> Guardian.Plug.sign_in(author.user_id)
        |> post(Routes.article_path(conn, :create), @create_attrs)
        |> json_response(201)

      query = from(a in Article, limit: 1)
      article = Repo.one(query)

      assert response == %{
               "data" => %{
                 "attributes" => %{
                   "body" => "body",
                   "description" => "description",
                   "published_date" => DateTime.to_iso8601(article.published_date),
                   "title" => "title"
                 },
                 "id" => article.id,
                 "relationships" => %{
                   "author" => %{"data" => %{"id" => article.author_id, "type" => "authors"}}
                 },
                 "type" => "articles"
               }
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      author = insert(:author)
      attrs = %{article: %{body: nil, title: nil}}

      response =
        conn
        |> Guardian.Plug.sign_in(author.user_id)
        |> post(Routes.article_path(conn, :create), attrs)
        |> json_response(422)

      assert response["errors"] == %{
               "body" => ["can't be blank"],
               "title" => ["can't be blank"]
             }
    end

    test "respond with 401 when unauthorized", %{conn: conn} do
      conn
      |> post(Routes.article_path(conn, :create), @create_attrs)
      |> response(401)
    end
  end

  describe "delete article" do
    test "deletes chosen article", %{conn: conn} do
      author = insert(:author)
      article = insert(:article, author: author)

      conn
      |> Guardian.Plug.sign_in(author.user_id)
      |> delete(Routes.article_path(conn, :delete, article.id))
      |> response(204)

      assert Journals.get_article(article.id) == {:error, :not_found}
    end

    test "respond with 404 when article not found", %{conn: conn} do
      author = insert(:author)

      conn
      |> Guardian.Plug.sign_in(author.user_id)
      |> delete(Routes.article_path(conn, :delete, 123))
      |> response(404)
    end

    test "respond with 403 when trying to delete not own article", %{conn: conn} do
      author1 = insert(:author)
      article1 = insert(:article, author: author1)
      author2 = insert(:author)

      conn
      |> Guardian.Plug.sign_in(author2.user_id)
      |> delete(Routes.article_path(conn, :delete, article1.id))
      |> response(403)
    end

    test "respond with 401 when unauthorized", %{conn: conn} do
      article = insert(:article)

      conn
      |> delete(Routes.article_path(conn, :delete, article.id))
      |> response(401)
    end
  end
end
