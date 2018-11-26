defmodule Acception.WebHttpWeb.PageController do
  use Acception.WebHttpWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
