defmodule Acception.WriterPg.Acceptor do

  use Acception.GenServer

  alias Acception.Domain.Entries.CreateEntriesCommand
  alias Acception.Domain.Repo
  alias Acception.ExecuteDbCommand

  # Public API ###################

  def start_link(args, opts \\ []), do: GenServer.start_link(__MODULE__, args, opts)

  # Private API ###################

  def init(_args) do
    {:ok, %{}}
  end

  def handle_call({:write, list}, _from, state) do
    write(list)

    {:reply, :ok, state}
  end

  def handle_call({:write_from_cache, queue_name}, _from, state) do
    write_from_cache(queue_name)

    {:reply, :ok, state}
  end

  # Private ##########

  defp write(list) do
    list
    |> Enum.map(&build_attrs/1)
    |> CreateEntriesCommand.operation()
    |> ExecuteDbCommand.transaction(Repo)
  end

  defp write_from_cache(queue_name) do
    queue_name
    |> all_cached()
    |> maybe_write()
  end

  defp build_attrs({level, app, timestamp, tags, msg}) when is_binary(timestamp) do
    {:ok, timestamp, _} = DateTime.from_iso8601(timestamp)

    build_attrs({level, app, timestamp, tags, msg})
  end

  defp build_attrs({level, app, timestamp, tags, msg}) do
    %{
      level: level,
      app: app,
      timestamp: timestamp,
      tags: tags,
      msg: msg,
    }
  end

  defp maybe_write(list) when length(list) > 0 do
    list
    |> Enum.map(&build_attrs/1)
    |> CreateEntriesCommand.operation()
    |> ExecuteDbCommand.transaction(Repo)
  end

  defp maybe_write(_list), do: nil

  defp all_cached(queue_name), do: GenServer.call(queue_name, :all)

end
