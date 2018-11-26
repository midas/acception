use Mix.Config

config :web_http,
  namespace: Acception.WebHttp

config :web_http, Acception.WebHttpWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5cY5lM/uhIGJzDb3V0ajeKEL45ta3W0YG6ocs0SDd9ZNsyqRXuLUI3SPSiqdU0ME",
  render_errors: [view: Acception.WebHttpWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Acception.WebHttp.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
