defmodule GraphqlMarkdown.Schema do
  @moduledoc """
  Internal Schema representation of Graphql section we care about
  """
  @typedoc """
   test
  """
  @type t :: %__MODULE__{
          mutations: list(map()),
          queries: list(map()),
          inputs: list(map()),
          objects: list(map()),
          enums: list(map()),
          scalars: list(map()),
          interfaces: list(map()),
          unions: list(map())
        }
  defstruct [:mutations, :queries, :inputs, :objects, :enums, :scalars, :interfaces, :unions]

  @object_kind "OBJECT"
  @input_kind "INPUT_OBJECT"
  @enum_kind "ENUM"
  @scalar_kind "SCALAR"
  @interface_kind "INTERFACE"
  @union_kind "UNION"

  def full_field_type(type) do
    case type["kind"] do
      "NON_NULL" ->
        "#{full_field_type(type["ofType"])}!"

      "LIST" ->
        "\\[#{full_field_type(type["ofType"])}\\]"

      _ ->
        type["name"]
    end
  end

  def field_type(type) do
    case type["kind"] do
      "NON_NULL" ->
        field_type(type["ofType"])

      "LIST" ->
        field_type(type["ofType"])

      _ ->
        type["name"]
    end
  end

  def field_kind(type) do
    case type["kind"] do
      "NON_NULL" ->
        field_type(type["ofType"])

      "LIST" ->
        field_type(type["ofType"])

      _ ->
        type["kind"]
    end
  end

  def object_kind do
    @object_kind
  end

  def input_kind do
    @input_kind
  end

  def enum_kind do
    @enum_kind
  end

  def scalar_kind do
    @scalar_kind
  end

  def interface_kind do
    @interface_kind
  end

  def union_kind do
    @union_kind
  end

  def mutation_type(schema) do
    schema["mutationType"]["name"]
  end

  def query_type(schema) do
    schema["queryType"]["name"]
  end

  def types(schema) do
    Enum.filter(schema["types"], fn type -> !String.starts_with?(type["name"], "__") end)
  end

  def schema_from_json(%{"data" => %{"__schema" => schema_definition}}) do
    {:ok, schema_definition}
  end

  def schema_from_json(_) do
    {:error, :invalid_schema}
  end

  def find_and_sort_type(types, field, value, sort_by \\ "name") do
    types
    |> find_type(field, value)
    |> sort_type(sort_by)
  end

  defp sort_type(types, sort_by) do
    Enum.sort_by(types, fn type -> type[sort_by] end)
  end

  defp find_type(types, field, value) do
    Enum.filter(types, fn type ->
      type[field] == value
    end)
  end
end
