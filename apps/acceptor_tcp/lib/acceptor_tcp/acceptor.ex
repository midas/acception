defmodule Acception.AcceptorTcp.Acceptor do

  require Logger

  def start_link(_args, _opts \\ []) do
    acceptors_size = Application.get_env(:acceptor_tcp, :acceptors_size, 20)
    port           = Application.get_env(:acceptor_tcp, :port, 9000)

    {:ok, _} =
      :ranch.start_listener(
        :tcp,
        acceptors_size,
        :ranch_tcp,
        [port: port],
        Acception.AcceptorTcp.Handler,
        []
      )
  end

end
