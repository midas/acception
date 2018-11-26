use Mix.Config

config :api_http,
  namespace: Acception.ApiHttp

config :api_http, Acception.ApiHttpWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kfg6jf75Rj2YNsQd/yM5bSGNpQ+9KUqFfweNfh+iFq6Ydc94vY/D4gIT2Uyz1pvW",
  render_errors: [view: Acception.ApiHttpWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Acception.ApiHttp.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{Mix.env()}.exs"
