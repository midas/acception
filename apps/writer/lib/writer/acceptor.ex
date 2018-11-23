defmodule Acception.Writer.Acceptor do

  use Acception.GenServer

  alias Acception.Writer.Processor

  # Public API ###################

  def start_link(args, opts \\ []), do: GenServer.start_link(__MODULE__, args, opts)

  # Private API ###################

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:write, level, app, timestamp, tags, metadata, msg}, _from, state) do
    Processor.call(level, app, timestamp, tags, metadata, msg)

    {:reply, :ok, state}
  end

end
