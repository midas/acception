use Mix.Config

config :domain, ecto_repos: [Acception.Domain.Repo]

import_config "#{Mix.env()}.exs"
