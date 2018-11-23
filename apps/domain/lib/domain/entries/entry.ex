defmodule Acception.Domain.Entries.Entry do

  use Acception.Domain, :schema

  schema "entries" do
    field :app, :string
    field :level, :string
    field :metadata, :map
    field :msg, :string
    field :tags, {:array, :string}
    field :timestamp, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  def insert_changeset(model \\ %__MODULE__{}, attrs) do
    model
    |> cast(attrs, ~w(
         app
         level
         metadata
         msg
         tags
         timestamp
       )a)
    |> validate_required(~w(msg)a)
  end

end
