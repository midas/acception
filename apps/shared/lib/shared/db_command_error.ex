defmodule Acception.DbCommandError do

  defexception changes_so_far: nil,
               failed_operation: nil,
               failed_value: nil,
               message: "command failed",
               plug_status: 500

  def new(failed_operation, failed_value, changes_so_far) do
    %__MODULE__{
      changes_so_far: changes_so_far,
      failed_operation: failed_operation,
      failed_value: failed_value,
      message: "command failed on operation: #{failed_operation}"
    }
  end

end
