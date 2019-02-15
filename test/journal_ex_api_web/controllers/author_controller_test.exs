defmodule JournalExApiWeb.AuthorControllerTest do
  use JournalExApiWeb.ConnCase

  alias JournalExApiWeb.Auth.Guardian
  import JournalExApi.Factory

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show author" do
    test "renders author", %{conn: conn} do
      author =
        insert(:author,
          first_name: "Morty",
          last_name: "Smith",
          age: 16
        )

      response =
        conn
        |> Guardian.Plug.sign_in(author.user_id)
        |> get(Routes.author_path(conn, :show, author.id))
        |> json_response(200)

      assert response == %{
               "data" => %{
                 "id" => author.id,
                 "type" => "authors",
                 "attributes" => %{
                   "first_name" => "Morty",
                   "last_name" => "Smith",
                   "age" => 16
                 }
               }
             }
    end

    test "renders error when author does not exist", %{conn: conn} do
      author = insert(:author)

      conn
      |> Guardian.Plug.sign_in(author.user_id)
      |> get(Routes.author_path(conn, :show, 123))
      |> response(404)
    end

    test "respond with 401 when unauthorized", %{conn: conn} do
      author = insert(:author)

      conn
      |> get(Routes.author_path(conn, :show, author.id))
      |> response(401)
    end
  end

  describe "update author" do
    @update_attrs %{
      author: %{
        first_name: "Morty",
        last_name: "Smith",
        age: 16
      }
    }

    test "renders author when data is valid", %{conn: conn} do
      author =
        insert(:author,
          first_name: "morty",
          last_name: "ssmith",
          age: 46
        )

      response =
        conn
        |> Guardian.Plug.sign_in(author.user_id)
        |> put(Routes.author_path(conn, :update), @update_attrs)
        |> json_response(200)

      assert response == %{
               "data" => %{
                 "id" => author.id,
                 "type" => "authors",
                 "attributes" => %{
                   "first_name" => "Morty",
                   "last_name" => "Smith",
                   "age" => 16
                 }
               }
             }

      response =
        conn
        |> Guardian.Plug.sign_in(author.user_id)
        |> get(Routes.author_path(conn, :show, author.id))
        |> json_response(200)

      assert response == %{
               "data" => %{
                 "id" => author.id,
                 "type" => "authors",
                 "attributes" => %{
                   "first_name" => "Morty",
                   "last_name" => "Smith",
                   "age" => 16
                 }
               }
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      author = insert(:author)

      attrs = %{
        author: %{
          first_name: nil,
          last_name: nil,
          age: nil
        }
      }

      response =
        conn
        |> Guardian.Plug.sign_in(author.user_id)
        |> put(Routes.author_path(conn, :update), attrs)
        |> json_response(422)

      assert response["errors"] == %{
               "age" => ["can't be blank"],
               "first_name" => ["can't be blank"],
               "last_name" => ["can't be blank"]
             }
    end

    test "respond with 401 when unauthorized", %{conn: conn} do
      conn
      |> put(Routes.author_path(conn, :update), @update_attrs)
      |> response(401)
    end
  end
end
