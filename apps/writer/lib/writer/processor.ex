defmodule Acception.Writer.Processor do

  def call(level, app, timestamps, tags, msg) do
    GenServer.call(:WriterQueue, {:enqueue, {level, app, timestamps, tags, msg}})
    GenServer.call(:WriterCacheCoordinator, :entry_arrived)
  end

end
