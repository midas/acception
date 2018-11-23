defmodule Acception.Domain.Repo.Migrations.AddEntries do

  use Acception.Domain.Seed

  envs ~w(dev)a
  tags ~w(base entries)a

  def up(repo) do
    {:ok, timestamp, _} = DateTime.from_iso8601("2018-11-22 00:00:01Z")
    EntriesEntry.insert_changeset(%{
      app: "app_1",
      level: "error",
      metadata: %{request_id: "ABC123"},
      msg: "This is a \n very important message",
      tags: ~w(tag_1 tag_2),
      timestamp: timestamp
    })
    |> repo.insert!()

    {:ok, timestamp, _} = DateTime.from_iso8601("2018-11-22 00:01:00Z")
    EntriesEntry.insert_changeset(%{
      app: "app_2",
      level: "error",
      metadata: %{request_id: "ABC123"},
      msg: "Another message",
      tags: ~w(tag_1),
      timestamp: timestamp
    })
    |> repo.insert!()

    {:ok, timestamp, _} = DateTime.from_iso8601("2018-11-22 00:01:30Z")
    EntriesEntry.insert_changeset(%{
      app: "app_1",
      level: "error",
      metadata: %{request_id: "ABC123"},
      msg: "This message",
      tags: ~w(tag_2),
      timestamp: timestamp
    })
    |> repo.insert!()
  end

end
