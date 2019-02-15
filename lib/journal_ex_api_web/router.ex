defmodule JournalExApiWeb.Router do
  use JournalExApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug JournalExApiWeb.Auth.Pipeline
  end

  scope "/api", JournalExApiWeb do
    pipe_through :api
    post "/users/sign_up", UserController, :sign_up
    post "/users/sign_in", UserController, :sign_in
  end
  end
end
