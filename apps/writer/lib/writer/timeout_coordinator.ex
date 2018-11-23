defmodule Acception.Writer.TimeoutCoordinator do
  @moduledoc """
  The TimeoutCoordinator handles publishing the need to write entries
  based on reaching the configured timeout_coordinator_interval_in_ms.
  """
  use Acception.RepetitiveTask, write: Application.get_env(:writer, :timeout_coordinator_interval_in_ms)

  alias Acception.Writer.Publisher

  defp perform_task(:write) do
    Publisher.call()
  end

end
