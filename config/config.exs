# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :journal_ex_api,
  ecto_repos: [JournalExApi.Repo]

# Configures the endpoint
config :journal_ex_api, JournalExApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "6CdUTc+NV1uHvQszQaaDTfB/YgEc6P67TlqcLHt2L5GUDksNMzi514ZglPua+oGI",
  render_errors: [view: JournalExApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: JournalExApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :journal_ex_api, JournalExApiWeb.Auth.Guardian,
  issuer: "journal_ex_api",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
