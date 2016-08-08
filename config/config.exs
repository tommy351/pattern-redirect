# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :pattern_redirect,
  ecto_repos: [PatternRedirect.Repo]

# Configures the endpoint
config :pattern_redirect, PatternRedirect.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7tudfhhJToQgs6G1rxAy3vFLy/I+sSu/2o/RTN9QFWICs7tPpFTPman8aHlQL/p+",
  render_errors: [view: PatternRedirect.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PatternRedirect.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
