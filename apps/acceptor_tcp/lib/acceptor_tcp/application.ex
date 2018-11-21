defmodule Acception.AcceptorTcp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      worker(Acception.AcceptorTcp.Acceptor, [[], [name: :TcpAcceptor]]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Acception.AcceptorTcp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
