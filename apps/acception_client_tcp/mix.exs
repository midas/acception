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
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description do
    """
    The official Elixir TCP client for the Acception log/error aggregation app.
    """
  end

  defp package do
    [
      name: :acception_client_tcp,
      files: [
        "lib",
        "mix.exs",
        "README*",
        "LICENSE*"
      ],
      maintainers: ["C. Jason Harrelson"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/midas/acception",
        "Docs" => "https://hexdocs.pm/acception/0.1.0"
      }
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

      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

end
