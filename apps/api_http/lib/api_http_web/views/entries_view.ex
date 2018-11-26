defmodule Acception.ApiHttpWeb.EntriesView do
  use Acception.ApiHttpWeb, :view

  def render("index.csv", %{}) do
    "hello,world"
  end

  def render("index.json", %{}) do
    %{hello: "world"}
  end

end
