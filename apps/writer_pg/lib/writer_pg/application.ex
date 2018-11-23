defmodule Acception.WriterPg.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      Acception.WriterPg.Repo,
      worker(Acception.WriterPg.Acceptor, [[], [name: :WriterPgAcceptor]]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Acception.WriterPg.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
