defmodule Acception.Domain.Seed do
  defmacro __using__(_opts) do
    quote do
      use PhilColumns.Seed
      alias Acception.Domain.Entries.Entry, as: EntriesEntry
    end
  end
end
