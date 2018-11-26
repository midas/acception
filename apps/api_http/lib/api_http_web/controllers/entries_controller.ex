defmodule Acception.ApiHttpWeb.EntriesController do
  use Acception.ApiHttpWeb, :controller

  def index(conn, params) do
    conn
    |> render()
  end

end
