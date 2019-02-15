defmodule JournalExApi.Repo do
  use Ecto.Repo,
    otp_app: :journal_ex_api,
    adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10
end
