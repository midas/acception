defmodule Proximity.Api.Repo.Migrations.TurnOnCitextExtension do
  use Ecto.Migration

  def up do
    #unless Application.get_env( :api, :env ) == :prod do
      execute "CREATE EXTENSION IF NOT EXISTS citext"
    #end
  end

  def down do
    #unless Application.get_env( :api, :env ) == :prod do
      execute "DROP EXTENSION IF EXISTS citext"
    #end
  end

end
