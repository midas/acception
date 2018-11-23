defmodule Acception.ClientTcp.Client do

  defmacro __using__(opts) do
    quote do

      use GenServer

      @connected :connected
      @delimiter <<255, 0, 170, 85>>
      @disconnected :disconnected
      @message_pack_identifier "MPCK"

      # Public API ###################

      def start_link(args, opts \\ []), do: GenServer.start_link(__MODULE__, args, opts)

      def send(client, level, app, timestamp, tags \\ [], msg) do
        GenServer.call(client, {:send, level, app, timestamp, tags, msg})
      end

      # Private API ###################

      def init(_args) do
        Process.send_after(self(), :connect, 0)

        {:ok, %{retries: 0,
                socket: nil,
                status: @disconnected}}
      end

      def handle_call({:send, level, app, timestamp, tags, msg},
                      _from,
                      %{socket: socket, status: status} = state)
      do
        _send(status, socket, level, app, timestamp, tags, msg)

        {:reply, :ok, state}
      end

      def handle_info(:connect, state) do
        connect(state)
      end

      def handle_info({:tcp, socket, tcp_frame}, state) do
        tcp(socket, tcp_frame)

        {:noreply, state}
      end

      def handle_info({:tcp_closed, socket}, state) do
        tcp_closed(socket, :unknown, state)
      end

      def handle_info({:tcp_error, socket, reason}, state) do
        tcp_closed(socket, reason, state)
      end

      # Private ##########

      defp _send(@disconnected, _socket, _level, _app, _timestamp, _tags, _msg) do
        # TODO cache until connected
      end

      defp _send(@connected, socket, level, app, timestamp, tags, msg) do
        bin_msg =
          Msgpax.pack!(%{
            type: "log",
            a: app,
            m: msg,
            tags: tags,
            ts: timestamp,
            l: level
          }, iodata: false)

        :gen_tcp.send(socket, @message_pack_identifier <> bin_msg <> @delimiter)
      end

      defp tcp(socket, _tcp_frame) do
        :inet.setopts(socket, active: :once)
      end

      defp tcp_closed(socket, reason, state) do
        retry_connect(host(), port(), "unknown", state)
      end

      defp connect(state) do
        host()
        |> String.to_charlist()
        |> :gen_tcp.connect(port(), [:binary, active: :once, reuseaddr: true])
        |> handle_connect(state)
      end

      defp handle_connect({:ok, socket}, state) do
        {:noreply, %{state | retries: 0,
                             socket: socket,
                             status: @connected}}
      end

      defp handle_connect({:error, :econnrefused}, state)   do
        retry_connect(host(), port(), "refused", state)
      end

      defp handle_connect({:error, error}, _state), do: raise error

      defp retry_connect(host, port, reason, %{retries: retries} = state) do
        retry_in_ms = retry_timeout(retries)
        #Logger.warn(["Socket connection to ", host, ":", inspect(port), " ", reason, ", scheduling retry in ", inspect(retry_in_ms), " ms"])
        Process.send_after(self(), :connect, retry_in_ms)

        {:noreply, %{state | retries: (retries + 1),
                             status: @disconnected}}
      end

      defp retry_timeout(retries) when retries > 500, do: 60_000
      defp retry_timeout(retries) when retries > 200, do: 30_000
      defp retry_timeout(retries) when retries > 100, do: 15_000
      defp retry_timeout(retries) when retries > 50,  do: 10_000
      defp retry_timeout(retries) when retries > 25,  do: 5_000
      defp retry_timeout(retries) when retries > 10,  do: 2_500
      defp retry_timeout(_),                          do: 1_000

      defp host, do: Keyword.get(scoped_config(), :host)
      defp port, do: Keyword.get(scoped_config(), :port)

      defp scoped_config, do: Application.get_env(:acception_client_tcp, otp_app())

      defp otp_app, do: unquote(Keyword.get(opts, :otp_app))

    end
  end

end
