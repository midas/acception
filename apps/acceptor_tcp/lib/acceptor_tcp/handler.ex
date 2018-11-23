defmodule Acception.AcceptorTcp.Handler do

  #use Acception.GenServer

  require Logger

  # Public API ###################

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  # Private API ###################

  def init(ref, socket, transport, _opts = []) do
    :ok = :ranch.accept_ack(ref)

    case transport.peername(socket) do
      {:ok, _peer} -> loop(socket, transport, "")
      {:error, reason} -> Logger.error("[tcp.handler] init receive error reason: #{inspect(reason)}")
    end
  end

  defp loop(socket, transport, acc) do
    # Don't flood messages of transport, receive once and leave the remaining
    # data in socket until we run recv again.
    transport.setopts(socket, [active: :once])

    # before to proceed with receive block on messages we should call
    # once transport.messages() to ping ranch
    {:tcp, :tcp_closed, :tcp_error} = transport.messages()

    receive do
      {:tcp, socket, data} ->
        #Logger.debug("[tcp.handler] received data: #{inspect(data)}")

				(acc <> data)
        |> String.split(delimiter())
        |> Enum.map(&String.trim/1)
        |> process(socket, transport)

        loop(socket, transport, "")
      {:tcp_closed, socket} ->
        Logger.debug("[tcp.handler] closed socket: #{inspect(socket)}")
      {:tcp_error, socket, reason} ->
        Logger.error("[tcp.handler] socket: #{inspect(socket)}, closed becaose of the error reason: #{inspect(reason)}")
      {:tcp_error, reason} ->
        Logger.error("[tcp.handler] error: #{inspect(reason)}")
      {'EXIT', _pid, reason} ->
        Logger.error("[tcp.handler] exit parent reason: #{inspect(reason)}")
        Process.exit(self(), :kill)
      message ->
        Logger.warn("[tcp.handler] message on receive block: #{inspect(message)}")
    end
  end

  #defp kill, do: Process.exit(self(), :kill)

  defp process([], socket, transport),           do: loop(socket, transport, "")
  defp process([""], socket, transport),         do: loop(socket, transport, "")
  defp process([msg, ""], socket, transport)     do
		protocol(msg, socket, transport)
    loop(socket, transport, "")
  end
  defp process([msg], socket, transport),       do: loop(socket, transport, msg)
  defp process([msg | msgs], socket, transport) do
		protocol(msg, socket, transport)
    process(msgs, socket, transport)
  end

  defp protocol(msg, _socket, _transport) do
    #Logger.debug("[protocol] msg: #{msg}")
    Acception.AcceptorTcp.Protocol.process(msg)
  end

  defp delimiter, do: Application.get_env(:acceptor_tcp, :delimiter)

end
