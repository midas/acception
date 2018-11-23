defmodule Acception.Query do

  defmacro __using__( _opts ) do
    quote do

      import Ecto.Query

      defp apply_field_filters( query, opts ) do
        field_sets = Keyword.get( opts, :fields, [] )

        Enum.reduce( field_sets, query, fn({table_name, fields}, query) ->
          limit_fields( query, table_name, fields )
        end)
      end

      defp limit_fields( query, _, _ ), do: query

      defp extract_id_if_model( model_or_id ) when is_integer(model_or_id) do
        model_or_id
      end

      defp extract_id_if_model( model_or_id ) when is_binary(model_or_id) do
        model_or_id
        |> String.to_integer
      end

      defp extract_id_if_model( model_or_id ) do
        model_or_id.id
      end

      defp extract_identifier_if_model( model_or_identifier ) when is_binary(model_or_identifier) do
        model_or_identifier
      end

      defp extract_identifier_if_model( model_or_identifier ) do
        model_or_identifier.id
      end

      defp clean_attrs( attrs, [] ) do
        clean_attrs( attrs, nil )
      end

      defp clean_attrs( attrs, nil ) do
        attrs
        |> Enum.reject( fn({_,v}) -> v == nil || v == "" end )
        |> Enum.into( %{} )
      end

      defp clean_attrs( attrs, attrs_to_take ) do
        Map.take( attrs, attrs_to_take )
        |> clean_attrs( nil )
      end

      defoverridable [
        limit_fields: 3
      ]

    end
  end

end
