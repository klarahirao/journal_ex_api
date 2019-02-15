defmodule JournalExApiWeb.UserView do
  use JournalExApiWeb, :view
  alias JournalExApiWeb.UserResource

  def render("user.json", %{user: user, token: token}) do
    %{data: UserResource.build(user, token)}
  end
end
