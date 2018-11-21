defmodule Acception.GenServer do

  defmacro __using__(_opts) do
    quote do

      use GenServer

      defp schedule(event, time_in_ms), do: Process.send_after(self(), event, time_in_ms)

      defp cancel_timer(nil), do: false

      defp cancel_timer(timer), do: Process.cancel_timer(timer)

    end
  end

end
