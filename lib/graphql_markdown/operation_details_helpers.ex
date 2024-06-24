defmodule GraphqlMarkdown.OperationDetailsHelpers do
  @moduledoc """
  A set of helpers to generate query and mutation details.
  """

  alias GraphqlMarkdown.Schema

  @type argument :: %{
          name: String.t(),
          type: String.t(),
          required: boolean()
        }

  @type field :: %{
          name: String.t(),
          type: String.t()
        }

  @type return_type :: %{
          name: String.t(),
          kind: String.t(),
          fields: [field()]
        }

  @type graphql_operation_details :: %{
          operation_type: String.t(),
          operation_name: String.t(),
          arguments: [argument()],
          return_type: return_type()
        }

  @doc """
  Creates a map with the details of a query or mutation. The details created include
  the operation type, operation name, arguments, and return type.
  """
  @spec generate_operation_details(String.t(), map(), GraphqlMarkdown.Schema.t()) ::
          graphql_operation_details()
  def generate_operation_details(type, field, schema_details) do
    operation_type =
      case type do
        "queries" -> "query"
        "mutations" -> "mutation"
      end

    arguments = operation_arguments(field["args"])

    operation_details = %{
      operation_type: operation_type,
      operation_name: field["name"],
      arguments: arguments,
      return_type: return_fields(field["type"], schema_details)
    }

    operation_details
  end

  @spec operation_arguments([map()]) :: [argument()]
  defp operation_arguments(args) do
    Enum.map(args, fn arg ->
      arg_type = arg["type"]
      type = Schema.field_type(arg_type)
      required = arg_type["kind"] == "NON_NULL"

      %{
        name: arg["name"],
        type: type,
        required: required
      }
    end)
  end

  @spec return_fields(map(), GraphqlMarkdown.Schema.t()) :: return_type()
  defp return_fields(%{"name" => name, "kind" => "OBJECT"}, schema_details) do
    object_fields =
      schema_details
      |> Map.get(:objects, [])
      |> Enum.find(fn object -> object["name"] == name end)
      |> Map.get("fields", [])
      |> Enum.map(fn field ->
        field_name = field["name"]
        type = return_field_type(field)
        %{name: field_name, type: type}
      end)

    %{
      name: name,
      kind: "OBJECT",
      fields: object_fields
    }
  end

  defp return_fields(return_type, _schema_details) do
    %{
      name: return_type["name"],
      kind: return_type["kind"],
      fields: []
    }
  end

  @spec return_field_type(map()) :: String.t()
  defp return_field_type(%{"type" => %{"kind" => "NON_NULL"}} = field) do
    get_in(field, ["type", "ofType", "kind"])
  end

  defp return_field_type(field) do
    get_in(field, ["type", "kind"])
  end
end
