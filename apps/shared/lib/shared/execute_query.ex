defmodule Acception.ExecuteQuery do

  require Logger

  import Ecto.Query, only: [from: 2]

  alias Acception.{KeywordUtil, UndefinedScope}

  @default_structure    :status
  @pagination_opt_names ~w(page page_size)a

  def all(query, repo, opts \\[])

  def all(%UndefinedScope{}, _repo, opts) do
    Keyword.get(opts, :structure, @default_structure)
    |> do_process_result([])
  end

  def all(query, repo, opts) do
    fields = Keyword.get(opts, :fields)
    order  = Keyword.get(opts, :order)

    query
    |> apply_fields(fields)
    |> apply_order(order)
    |> repo.all()
    |> process_result(opts)
  end

  def one(query, repo, opts \\ [])

  def one(%UndefinedScope{}, _repo, opts) do
    Keyword.get(opts, :structure, @default_structure)
    |> do_process_result(nil)
  end

  def one(query, repo, opts) do
    fields = Keyword.get(opts, :fields)

    query
    |> apply_fields(fields)
    |> repo.one()
    |> process_result(opts)
  end

  def paginate(query, repo, opts) when is_list(opts) do
    {query_opts, opts} = KeywordUtil.partition_by_keys(opts, @pagination_opt_names)

    execute_paginated(query, repo, Enum.into(query_opts, %{}), opts)
  end

  # Private ##########

  defp apply_fields(query, nil),   do: query
  defp apply_fields(query, fields) do
    from [x,...] in query,
      select: struct(x, ^fields)
  end

  defp apply_order(query, nil),  do: query
  defp apply_order(query, order) do
    from _ in query,
    order_by: ^order
  end

  defp execute_paginated(query, repo, params, opts) do
    fields = Keyword.get(opts, :fields)
    order  = Keyword.get(opts, :order)

    query
    |> apply_fields(fields)
    |> apply_order(order)
    |> repo.paginate(params)
    |> process_paginated_result(opts)
  end

  defp process_result(items, opts) do
    Keyword.get(opts, :structure, @default_structure)
    |> do_process_result(items)
  end

  defp process_paginated_result(page, opts) do
    Keyword.get(opts, :structure, @default_structure)
    |> do_process_paginated_result(page)
  end

  defp do_process_result(:status, nil),   do: :not_found
  defp do_process_result(:status, []),    do: :not_found
  defp do_process_result(:status, items), do: {:ok, items}
  defp do_process_result(:naked, items),  do: items

  defp do_process_paginated_result(:status, %{entries: []} = page), do: {:not_found, page}
  defp do_process_paginated_result(:status, page),                  do: {:ok, page}
  defp do_process_paginated_result(:naked, page),                   do: page

end
