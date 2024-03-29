# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :node_mock,
  ecto_repos: [NodeMock.Repo]

config :node_mock, NodeMock.BlockProducer,
  block_probability: 0.2,
  orphan_probability: 0.1


# Configures the endpoint
config :node_mock, NodeMockWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qiJaKNPTg2OAB5QJJoa3qbEHqLjlnKD+nD6rY0Pad5H5tKPCtXj1i+vzTzqwlH/O",
  render_errors: [view: NodeMockWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: NodeMock.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
