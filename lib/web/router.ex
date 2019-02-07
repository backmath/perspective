defmodule Web.Router do
  use Phoenix.Router

  # pipeline :api do
  #   plug :accepts, ["json", "html"]
  # end

  # scope "/", Web do
  # pipe_through :api

  get("/", Web.Controller, :index)
  get("/inc", Web.Controller, :inc)
  # end
end
