defmodule Acception.UndefinedScope do
  @moduledoc """
  Used to trigger no query execution against a Repo by ExecuteQuery.  Useful
  when building searches based off presence of search attribute(s).  One may
  not want to issue a query for every item in a schema when no search attributes
  are populated.
  """

  defstruct from_module: nil

  def new(from_module), do: %__MODULE__{from_module: from_module}
  def new(),            do: %__MODULE__{}

end
