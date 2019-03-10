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

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :perspective, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:Perspective, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
import_config "config.#{Mix.env()}.exs"
