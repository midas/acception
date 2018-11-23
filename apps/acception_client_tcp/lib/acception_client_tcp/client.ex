defmodule Acception.ClientTcp.Client do

  defmacro __using__(opts) do
    quote do

      use GenServer

      @delimiter <<255, 0, 170, 85>>
      @message_pack_identifier "MPCK"

      # Public API ###################

      def start_link(args, opts \\ []), do: GenServer.start_link(__MODULE__, args, opts)

      def send(client, level, app, timestamp, tags \\ [], msg) do
        GenServer.call(client, {:send, level, app, timestamp, tags, msg})
      end

      # Private API ###################

      def init(_args) do
        Process.send_after(self(), :connect, 0)

        {:ok, %{socket: nil}}
      end

      def handle_call({:send, level, app, timestamp, tags, msg},
                      _from,
                      %{socket: socket} = state)
      do
        _send(socket, level, app, timestamp, tags, msg)

        {:reply, :ok, state}
      end

      def handle_info(:connect, state) do
        socket = connect()

        {:noreply, %{state | socket: socket}}
      end

      # Private ##########

      defp _send(socket, level, app, timestamp, tags, msg) do
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

      defp connect do
        ip_address()
        |> String.to_charlist()
        |> :gen_tcp.connect(port(), [active: false])
        |> handle_connect()
      end

      defp handle_connect({:ok, socket}),   do: socket
      defp handle_connect({:error, error}), do: raise error

      defp ip_address, do: Keyword.get(scoped_config(), :ip_address)
      defp port,        do: Keyword.get(scoped_config(), :port)

      defp scoped_config, do: Application.get_env(:acception_client_tcp, otp_app())

      defp otp_app, do: unquote(Keyword.get(opts, :otp_app))

    end
  end

end
