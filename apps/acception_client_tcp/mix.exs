defmodule Acception.ClientTcp.MixProject do
  use Mix.Project

  def project do
    [
      app: :acception_client_tcp,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [
        :logger
      ]
    ]
  end

  defp deps do
    [
      {:msgpax, "~> 2.1"},
    ]
  end

end
