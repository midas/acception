defmodule Acception.ExecuteDbCommand do

  alias Acception.DbCommandError

  def transaction(operation, repo, _opts \\ []) do
    operation
    |> repo.transaction()
    |> handle_transaction_result()
  end

  # Private ##########

  defp handle_transaction_result({:ok, multi}), do: {:ok, multi}

  defp handle_transaction_result({:error, failed_operation, failed_value, changes_so_far}) do
    {:error, DbCommandError.new(failed_operation, failed_value, changes_so_far)}
  end

end
