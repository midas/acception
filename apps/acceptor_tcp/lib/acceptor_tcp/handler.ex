defmodule Acception.AcceptorTcp.Handler do

  #use Acception.GenServer

  require Logger

  @delimiter <<255, 0, 170, 85>>

  @timeout 5_000

  # Public API ###################

  def start_link(ref, socket, transport, opts) do
    pid = spawn_link(__MODULE__, :init, [ref, socket, transport, opts])
    {:ok, pid}
  end

  def init(ref, socket, transport, _opts = []) do
    :ok = :ranch.accept_ack(ref)

    case transport.peername(socket) do
      {:ok, _peer} -> loop(socket, transport, "")
      {:error, reason} -> Logger.error("[tcp.handler] init receive error reason: #{inspect(reason)}")
    end
  end

  def loop(socket, transport, acc) do
    # Don't flood messages of transport, receive once and leave the remaining
    # data in socket until we run recv again.
    transport.setopts(socket, [active: :once])

    # before to proceed with receive block on messages we should call
    # once transport.messages() to ping ranch
    {ok, closed, error} = transport.messages()

    receive do
      {ok, socket, data} ->
        Logger.debug("[tcp.handler] received data: #{inspect(data)}")

				(acc <> data)
        |> String.split(@delimiter)
        |> Enum.map(&String.trim/1)
        |> process(socket, transport)

        loop(socket, transport, "")
      {closed, socket} ->
        Logger.debug("[tcp.handler] closed socket: #{inspect(socket)}")
      {error, socket, reason} ->
        Logger.error("[tcp.handler] socket: #{inspect(socket)}, closed becaose of the error reason: #{inspect(reason)}")
      {:error, error} ->
        Logger.error("[tcp.handler] error: #{inspect(error)}")
      {'EXIT', parent, reason} ->
        Logger.error("[tcp.handler] exit parent reason: #{inspect(reason)}")
        Process.exit(self(), :kill)
      message ->
        Logger.debug("[tcp.handler] message on receive block: #{inspect(message)}")
    end
  end

  defp kill(), do: Process.exit(self(), :kill)

  defp process([], socket, transport),            do: loop(socket, transport, "")
  defp process([""], socket, transport),          do: loop(socket, transport, "")
  defp process([msg, ""], socket, transport)     do
		protocol(msg, socket, transport)
    loop(socket, transport, "")
  end
  defp process([msg], socket, transport),        do: loop(socket, transport, msg)
  defp process([msg | msgs], socket, transport) do
		protocol(msg, socket, transport)
    process(msgs, socket, transport)
  end

  defp protocol(msg, socket, transport) do
    Logger.debug("[protocol] msg: #{msg}")
    Acception.AcceptorTcp.Protocol.process(msg)
  end

end
