defmodule GraphqlMarkdown do
  @moduledoc """
  Converts a GraphQL JSON schema to a markdown format
  """
  alias GraphqlMarkdown.MultiPage
  alias GraphqlMarkdown.Schema
  alias GraphqlMarkdown.SinglePage

  @doc """
  Perform the conversion to generate the markdown files

  """
  @spec generate(keyword()) :: {:ok, list(binary())} | {:error, any}
  def generate(options) do
    with {:ok, json} <- load_json(options),
         {:ok, schema} <- Schema.schema_from_json(json) do
      {:ok, render_schema(schema, options)}
    end
  end

  defp load_json(options) do
    with {:ok, body} <- File.read(options[:schema]) do
      Jason.decode(body)
    end
  end

  defp render_schema(schema, options) do
    query_type_name = Schema.query_type(schema)
    mutation_type_name = Schema.mutation_type(schema)
    subscription_type_name = Schema.subscription_type(schema)
    types = Schema.types(schema)

    filtered_types =
      Enum.filter(types, fn type ->
        type["name"] != query_type_name && type["name"] != mutation_type_name
      end)

    schema_details = %Schema{
      mutations: List.first(Schema.find_and_sort_type(types, "name", mutation_type_name)),
      queries: List.first(Schema.find_and_sort_type(types, "name", query_type_name)),
      subscriptions: List.first(Schema.find_and_sort_type(types, "name", subscription_type_name)),
      inputs: Schema.find_and_sort_type(filtered_types, "kind", Schema.input_kind()),
      objects: Schema.find_and_sort_type(filtered_types, "kind", Schema.object_kind()),
      scalars: Schema.find_and_sort_type(filtered_types, "kind", Schema.scalar_kind()),
      enums: Schema.find_and_sort_type(filtered_types, "kind", Schema.enum_kind()),
      interfaces: Schema.find_and_sort_type(filtered_types, "kind", Schema.interface_kind()),
      unions: Schema.find_and_sort_type(filtered_types, "kind", Schema.union_kind())
    }

    generate_strategy(options[:multi_page]).render_schema(schema_details, options)
  end

  defp generate_strategy(true) do
    MultiPage
  end

  defp generate_strategy(_) do
    SinglePage
  end
end
