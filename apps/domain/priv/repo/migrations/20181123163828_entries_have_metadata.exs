defmodule Acception.Domain.Repo.Migrations.EntriesHaveMetadata do

  use Ecto.Migration

  def change do
    alter table(:entries) do
      add :metadata, :map
    end
  end

end
