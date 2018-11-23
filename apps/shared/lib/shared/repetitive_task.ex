defmodule Acception.RepetitiveTask do

  defmacro __using__( opts ) do
    quote do

      use GenServer

      require Logger

      def start_link( args, opts \\ [] ) do
        GenServer.start_link __MODULE__, args, opts
      end

      # Private API ##########

      def init( _args ) do
        schedule_tasks()

        {:ok, opts()}
      end

      def handle_info( identifier, state ) do
        timeout = Keyword.get( state, identifier )
        schedule_task( identifier, timeout )

        perform_task( identifier )

        {:noreply, state}
      end

      # Private ##########

      defp perform_task( identifier ) do
        Logger.warn("You must override #{__MODULE__} perform_task/1")
      end

      defp schedule_tasks do
        Enum.each( opts(), fn({identifier, timeout}) ->
          schedule_task( identifier, timeout )
        end)
      end

      defp schedule_task( identifier, timeout ) do
        debug "SCHEDULE TASK #{identifier} with timeout #{timeout}"
        Process.send_after( self(), identifier, timeout )
      end

      defp debug(msg), do: nil
      defp error(msg), do: nil
      defp info(msg),  do: nil
      defp warn(msg),  do: nil

      defp opts, do: unquote(opts)

      defoverridable [
        perform_task: 1,
        debug: 1,
        error: 1,
        info: 1,
        warn: 1
      ]

    end
  end

end
