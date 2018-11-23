defmodule Acception.Domain.Repo.Migrations.CreateEntries do

  use Ecto.Migration

  def change do
    create table :entries do
      add :app, :string, size: 100
      add :level, :string, size: 10
      add :tags, {:array, :string}
      add :timestamp, :utc_datetime
      add :msg, :text, null: false

      timestamps(type: :utc_datetime)
    end

    create index(:entries, [:app, :level])
    create index(:entries, [:app, :timestamp])
    create index(:entries, [:app, :level, :timestamp])
    create index(:entries, [:level, :timestamp])
  end

end
