defmodule Acception.Writer.Processor do

  def call(level, app, timestamps, tags, metadata, msg) do
    GenServer.call(:WriterQueue, {:enqueue, {level, app, timestamps, tags, metadata, msg}})
    GenServer.call(:WriterCacheCoordinator, :entry_arrived)
  end

end
