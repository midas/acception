defmodule Acception.ApiHttpWeb.Router do
  use Acception.ApiHttpWeb, :router

  pipeline :api do
    plug :accepts, ~w(csv json)
  end

  scope "/", Acception.ApiHttpWeb do
    pipe_through :api

    get "/entries", EntriesController, :index
  end

end
