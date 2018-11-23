defmodule Acception.AcceptorTcp.Protocol do
  @moduledoc """
  The protocol data interchange format can be message pack or JSON.  The
  structure is a map represented as a binary with a 4 character identifier
  in front of it.  The current identifiers are MPCK and JSON.

  The log message unpacked format is:
  %{
    "type" => "log",
    "l" => level,
    "a" => app,
    "ts" => timestamp,
    "tags" => ["tag1", ...],
    "m" => message
  }

  The type, level, timestamp and message is required.
  """
  require Logger

  def process("JSON" <> msg) do
    msg
    |> Jason.decode()
    |> handle_json_decode()
  end

  def process("MPCK" <> msg) do
    msg
    |> Msgpax.unpack()
    |> handle_msgpack_unpack()
  end

  def process(msg), do: Logger.error(["Unknown data interchange format: ", msg])

  defp handle_json_decode({:ok, msg_as_map}) do
    handle_msg(msg_as_map)
  end

  defp handle_json_decode({:error, error}) do
    raise error
  end

  defp handle_msgpack_unpack({:ok, msg_as_map}) do
    handle_msg(msg_as_map)
  end

  defp handle_msgpack_unpack(%Msgpax.UnpackError{reason: reason}) do
    raise reason
  end

  defp handle_msg(%{"type" => "log",
                    "l"    => level,
                    "a"    => app,
                    "tags" => tags,
                    "ts"   => timestamp,
                    "md"   => metadata,
                    "m"    => msg})
    when is_list(tags)
  do
    GenServer.call(:WriterAcceptor, {:write, level, app, timestamp, tags, metadata, msg})
  end

  defp handle_msg(%{"type" => "log",
                    "l"    => level,
                    "a"    => app,
                    "tags" => tags,
                    "ts"   => timestamp,
                    "m"    => msg})
    when is_list(tags)
  do
    GenServer.call(:WriterAcceptor, {:write, level, app, timestamp, tags, nil, msg})
  end

  defp handle_msg(%{"type" => "log",
                    "l"    => level,
                    "a"    => app,
                    "ts"   => timestamp,
                    "md"   => metadata,
                    "m"    => msg})
  do
    GenServer.call(:WriterAcceptor, {:write, level, app, timestamp, nil, metadata, msg})
  end

  defp handle_msg(%{"type" => "log",
                    "l"    => level,
                    "a"    => app,
                    "ts"   => timestamp,
                    "m"    => msg})
  do
    GenServer.call(:WriterAcceptor, {:write, level, app, timestamp, nil, nil, msg})
  end

  defp handle_msg(%{"type" => "log",
                    "l"    => level,
                    "tags" => tags,
                    "ts"   => timestamp,
                    "md"   => metadata,
                    "m"    => msg})
  do
    GenServer.call(:WriterAcceptor, {:write, level, nil, timestamp, tags, metadata, msg})
  end

  defp handle_msg(%{"type" => "log",
                    "l"    => level,
                    "tags" => tags,
                    "ts"   => timestamp,
                    "m"    => msg})
  do
    GenServer.call(:WriterAcceptor, {:write, level, nil, timestamp, tags, nil, msg})
  end

  defp handle_msg(%{"type" => "log",
                    "l"    => level,
                    "ts"   => timestamp,
                    "md"   => metadata,
                    "m"    => msg})
  do
    GenServer.call(:WriterAcceptor, {:write, level, nil, timestamp, nil, metadata, msg})
  end

  defp handle_msg(%{"type" => "log",
                    "l"    => level,
                    "ts"   => timestamp,
                    "m"    => msg})
  do
    GenServer.call(:WriterAcceptor, {:write, level, nil, timestamp, nil, nil, msg})
  end

  defp handle_msg(msg) do
    Logger.error(["Unknown msg type: ", inspect(msg)])
  end

end
