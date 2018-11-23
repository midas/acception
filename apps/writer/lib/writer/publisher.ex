defmodule Acception.Writer.Publisher do

  def call do
    GenServer.call(:WriterPgAcceptor, {:write_from_cache, :WriterQueue})
  end

end
