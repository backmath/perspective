use Mix.Config

config :perspective, Web.Endpoint,
  url: [host: "${HOST}"],
  http: [port: "8000"],
  secret_key_base: "${SECRET_KEY_BASE}",
  server: true,
  check_origin: [
    # What should go here?
  ],
  # code_reloader: true,
  # live_reload: [
  #   patterns: [
  #     ~r{lib/.*(ex)$},
  #   ]
  # ],
  # reloadable_compilers: [:gettext, :phoenix, :elixir],
  # reloadable_apps: [:perspective, :web],
  pubsub: [name: Web.PubSub, adapter: Phoenix.PubSub.PG2]

config :perspective, Web.PubSub, pubsub: [name: Web.PubSub, adapter: Phoenix.PubSub.PG2]

config :perspective, Perspective.Guardian,
  issuer: "perspective",
  secret_key: "[REDACTED]"

config :phoenix, :json_library, Jason
config :phoenix, :format_encoders, json: Jason

import_config "config.#{Mix.env()}.exs"
