defmodule Acception.AcceptorTcp.Protocol do
  @moduledoc """
  The protocol data interchange format can be message pack or JSON.  The
  structure is a map represented as a binary with a 4 character identifier
  in front of it.  The current identifiers are MPCK and JSON.

  The log message unpacked format is:
  %{
    "type" => "log",
    "ts" => timestamp,
    "tags" => ["tag1", ...],
    "m" => message
  }

  The type, timestamp and message is required.
  """

  require Logger

  def process("MPCK" <> msg) do
    msg
    |> Msgpax.unpack()
    |> handle_msgpack_unpack()
  end

  def process(msg), do: Logger.error(["Unknown data interchange format: ", msg])

  defp handle_msgpack_unpack({:ok, %{"type" => "log",
                                     "tags" => tags,
                                     "ts"   => timestamp,
                                     "m"    => msg}})
    when is_list(tags)
  do
    Logger.info(["Log tagged msg: ", inspect([timestamp, tags, msg])])
  end

  defp handle_msgpack_unpack({:ok, %{"type" => "log",
                                     "ts"   => timestamp,
                                     "m"    => msg}})
  do
    Logger.info(["Log msg: ", inspect([timestamp, msg])])
  end

  defp handle_msgpack_unpack({:ok, msg}) do
    Logger.error(["Unknown msg type: ", inspect(msg)])
  end

  defp handle_msgpack_unpack(%Msgpax.UnpackError{reason: reason})do
    raise reason
  end

end
