defmodule Acception.Writer.CacheCoordinator do
  @moduledoc """
  The CacheCoordinator handles publishing the need to write entries
  based on reaching the configured min_cache_size_for_write.
  """
  use Acception.GenServer

  alias Acception.Writer.Publisher

  # Public API ###################

  def start_link(args, opts \\ []), do: GenServer.start_link(__MODULE__, args, opts)

  # Private API ###################

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call(:entry_arrived, _from, state) do
    entry_arrived(cache_size(), min_cache_size_for_write())

    {:reply, :ok, state}
  end

  # Private ###################

  defp entry_arrived(cache_size, min_cache_size_for_write)
    when cache_size >= min_cache_size_for_write
  do
    Publisher.call()
  end

  defp entry_arrived(_cache_size, _min_cache_size_for_write), do: nil

  defp cache_size, do: GenServer.call(:WriterQueue, :size)

  defp min_cache_size_for_write, do: Application.get_env(:writer, :min_cache_size_for_write)

end
