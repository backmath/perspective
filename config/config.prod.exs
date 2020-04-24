use Mix.Config

config :perspective, Perspective.Application, app_id: "production.perspective.com"

config :perspective, Perspective.EncryptionConfiguration.State,
  encryption_key: "example-encryption-key",
  authentication_data: "dev.perspectivelib.com"

config :perspective, Perspective.EventChain.CurrentPage.State, max_events_per_page: 4096

config :perspective, Perspective.LocalFileStorage,
  path: "./storage/dev/",
  skip_encryption?: true,
  skip_compression?: true
