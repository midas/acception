defmodule Acception.KeywordUtil do

  def atomize_keys( map ) do
    for {key, val} <- map, do: {atomize_key(key), val}
  end

  def stringify_keys( map ) do
    for {key, val} <- map, do: {stringify_key(key), val}
  end

  def partition_by_keys(list, keys) do
    Enum.split_with(list, fn({k,_}) -> Enum.member?(keys, k) end)
  end

  # Private ##########

  defp atomize_key(key) when is_atom(key),   do: key
  defp atomize_key(key) when is_binary(key), do: String.to_atom(key)

  defp stringify_key(key) when is_atom(key),   do: Atom.to_string(key)
  defp stringify_key(key) when is_binary(key), do: key

end
