defmodule Acception.WriterPg.MixProject do
  use Mix.Project

  def project do
    [
      app: :writer_pg,
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
      mod: {Acception.WriterPg.Application, []},
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
