defmodule JournalExApi.Repo do
  use Ecto.Repo,
    otp_app: :journal_ex_api,
    adapter: Ecto.Adapters.Postgres
end
