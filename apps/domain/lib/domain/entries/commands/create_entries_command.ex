defmodule Acception.Domain.Entries.CreateEntriesCommand do

  use Acception.Command

  alias Acception.Domain.Entries.Entry

  def operation(multi \\ Multi.new, attrs)
    when is_list(attrs)
  do
    attrs = Enum.map(attrs, &add_timestamps/1)

    multi
    |> Multi.insert_all(:create_entries, Entry, attrs)
  end

  defp add_timestamps(attrs) do
    timestamp =
      DateTime.utc_now()
      |> DateTime.truncate(:second)

    Map.merge(attrs, %{
      inserted_at: timestamp,
      updated_at: timestamp
    })
  end

end
