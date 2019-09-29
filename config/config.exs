use Mix.Config

config :perspective, Web.PubSub, pubsub: [name: Web.PubSub, adapter: Phoenix.PubSub.PG2]

config :perspective, Perspective.Core.Guardian,
  issuer: "perspective",
  secret_key: "[REDACTED]"

config :phoenix, :json_library, Jason
config :phoenix, :format_encoders, json: Jason

config :perspective, Perspective.Processor.RequestAuthenticator, module: Perspective.Authentication.DefaultAuthenticator

import_config "config.#{Mix.env()}.exs"
