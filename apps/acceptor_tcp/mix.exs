defmodule Acception.AcceptorTcp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :acceptor_tcp,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Acception.AcceptorTcp.Application, []},
      extra_applications: [
        :logger
      ]
    ]
  end

  defp deps do
    [
    ]
  end

end
