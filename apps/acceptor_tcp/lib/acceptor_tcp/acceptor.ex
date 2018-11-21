defmodule Acception.AcceptorTcp.Acceptor do

  require Logger

  def start_link(args, opts \\ []) do
    acceptors_size = Keyword.get(args, :acceptors_size, 20)
    port           = Keyword.get(args, :port, 9000)

    {:ok, _} = :ranch.start_listener(:tcp, acceptors_size, :ranch_tcp, [port: port], Acception.AcceptorTcp.Handler, [])
  end

end
