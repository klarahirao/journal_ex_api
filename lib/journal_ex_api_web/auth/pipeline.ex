defmodule JournalExApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :journal_ex_api,
    module: JournalExApiWeb.Auth.Guardian,
    error_handler: JournalExApiWeb.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
