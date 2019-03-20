use Mix.Config

config :perspective, Perspective.EventChainStorage, path: "./storage/test/"
config :perspective, Perspective.Config.Test, test_config: :expected_value

config :argon2_elixir,
  t_cost: 1,
  m_cost: 8
