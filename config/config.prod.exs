use Mix.Config

config :perspective, Perspective.Application, app_id: "com.perspective.prod"
config :perspective, Perspective.EventChain.PageStorage, path: "./storage/prod/"
config :perspective, Perspective.EventChain.Manifest, path: "./storage/prod/"
