defmodule Acception.ApiHttpWeb do

  def controller do
    quote do
      use Phoenix.Controller, namespace: Acception.ApiHttpWeb

      import Plug.Conn
      import Acception.ApiHttpWeb.Gettext
      alias Acception.ApiHttpWeb.Router.Helpers, as: Routes
    end
  end

  def view do
    quote do
      use Phoenix.View,
        root: "lib/api_http_web/templates",
        namespace: Acception.ApiHttpWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 1, get_flash: 2, view_module: 1]

      import Acception.ApiHttpWeb.ErrorHelpers
      import Acception.ApiHttpWeb.Gettext
      alias Acception.ApiHttpWeb.Router.Helpers, as: Routes
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import Acception.ApiHttpWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

end
