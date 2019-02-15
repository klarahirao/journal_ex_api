defmodule JournalExApiWeb.UserResource do
  @moduledoc false

  def build(user, token) do
    %{
      id: user.id,
      type: "users",
      attributes: %{
        token: token,
        username: user.username
      }
    }
  end
end
