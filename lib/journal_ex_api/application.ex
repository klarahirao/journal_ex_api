defmodule JournalExApi.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      JournalExApi.Repo,
      JournalExApiWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: JournalExApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    JournalExApiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
