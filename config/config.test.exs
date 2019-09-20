use Mix.Config

config :perspective, Perspective.Application, app_id: "com.perspective.test"
config :perspective, Perspective.EventChain.PageStorage, path: "./storage/test/"
config :perspective, Perspective.EventChain.Manifest, path: "./storage/test/"

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8

config :perspective, Perspective.EncryptionConfiguration.State,
  encryption_key: "example-encryption-key",
  authentication_data: "test.perspectivelib.com"

config :perspective, Perspective.EventChain.CurrentPage.State, max_events_per_page: 50

config :perspective, Perspective.LocalFileStorage,
  path: "./storage/test/",
  skip_encryption?: true,
  skip_compression?: true

config :perspective, Perspective.Config.Test.Example, test_config: :expected_value
config :perspective, Perspective.Config.Test.SpecialOverride, test_config: :expected_value

config :perspective, Perspective.Authentication, module: Perspective.Core.Authenticator
