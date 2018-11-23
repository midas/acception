defmodule Acception.Command do

  defmacro __using__( _opts ) do
    quote do

      alias Ecto.Multi

      defp ensure_ids( list ) do
        list
        |> Enum.map(&ensure_id/1)
      end

      defp ensure_id( item ) when is_integer(item), do: item
      defp ensure_id( %{} = item ),                 do: item.id

    end
  end

end
