defmodule Acception.ApiHttpWeb.Router do
  use Acception.ApiHttpWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Acception.ApiHttpWeb do
    pipe_through :api
  end
end
