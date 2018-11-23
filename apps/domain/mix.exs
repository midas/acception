defmodule Acception.Domain.MixProject do
  use Mix.Project

  def project do
    [
      app: :domain,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      mod: {Acception.Domain.Application, []},
      extra_applications: [
        :logger
      ]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:phil_columns, "~> 2.0"},
      #{:phil_columns, path: "../../../../personal/phil_columns_test/apps/phil_columns-ex", override: true},
      {:postgrex, ">= 0.0.0"},
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.mulligan": ["ecto.rollback -v 0", "ecto.migrate"],
      "phil_columns.fresh": [
        "ecto.mulligan",
        "phil_columns.seed -t base"
      ],
      "phil_columns.mulligan": [
        "ecto.mulligan",
        "phil_columns.rollback -v 0",
        "phil_columns.seed -t base"
      ],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end

end
