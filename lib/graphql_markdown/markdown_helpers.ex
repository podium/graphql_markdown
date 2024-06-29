defmodule GraphqlMarkdown.MarkdownHelpers do
  @moduledoc """
  A set of helpers to generate proper markdown easily
  """
  alias GraphqlMarkdown.OperationDetailsHelpers

  @spec header(String.t(), non_neg_integer(), boolean()) :: String.t()
  def header(text, level, capitalize \\ false)

  def header(text, level, true) do
    header(String.capitalize(text), level, false)
  end

  def header(text, level, _capitalize) do
    "#{String.duplicate("#", level)} #{text}"
  end

  @spec list(String.t(), non_neg_integer(), boolean()) :: String.t()
  def list(text, level, capitalize \\ false)

  def list(text, level, true) do
    list(String.capitalize(text), level, false)
  end

  def list(text, level, _capitalize) do
    "#{String.duplicate(" ", level * 2)}* #{text}"
  end

  @spec anchor(String.t(), String.t() | nil) :: String.t()
  def anchor(text, anchor_text \\ nil) do
    case anchor_text do
      nil ->
        link(text)

      _ ->
        link(text, "##{String.downcase(anchor_text)}")
    end
  end

  @spec link(String.t(), String.t() | nil) :: String.t()
  def link(text, url \\ nil) do
    case url do
      nil ->
        "[#{text}](##{String.downcase(text)})"

      _ ->
        "[#{text}](#{url})"
    end
  end

  @spec default_value(any()) :: String.t()
  def default_value(nil), do: ""

  def default_value(defaultValue) do
    "The default value is `#{defaultValue}`"
  end

  @spec code(String.t()) :: String.t()
  def code(text), do: "`#{text}`"

  @spec new_line() :: String.t()
  def new_line do
    "\n"
  end

  @spec table(list(), list()) :: String.t()
  def table(fields, rows) do
    headers =
      Enum.join(
        [
          "| " <> Enum.map_join(fields, " | ", fn {name, _} -> name end) <> " |",
          "| " <>
            Enum.map_join(fields, " | ", fn {name, _} ->
              length =
                name
                |> Atom.to_string()
                |> String.length()

              String.duplicate("-", length)
            end) <> " |"
        ],
        new_line()
      )

    data =
      Enum.map_join(rows, new_line(), fn row ->
        "| " <> Enum.join(row, " | ") <> " |"
      end)

    headers <> new_line() <> data
  end

  @doc """
  Generates a code block for a GraphQL operation. Only the top-level fields returned are represented in the code block.
  When one of the fields returned is an object, the object's fields are not included in the code block.

  Example:
    ```gql
    mutation RefreshIdToken($refreshToken: String!) {
      refreshIdToken(refreshToken: $refreshToken) {
        idToken
        userSsoDetails {
        }
      }
    }
    ```

    In this example, the `idToken` field is a scalar, so it is included in the code block.
    In this example the `userSsoDetails` field is an object, so its fields are not included in the code block.
  """
  @spec graphql_operation_code_block(OperationDetailsHelpers.graphql_operation_details()) ::
          String.t()
  def graphql_operation_code_block(operation_details) do
    %{
      operation_name: operation_name,
      operation_type: operation_type,
      arguments: args,
      return_type: return_type
    } =
      operation_details

    capitalized_operation_name = capitalize_operation_name(operation_name)

    arguments_types = argument_types_string(args)
    arguments = operation_arguments_string(args)

    return_fields = returned_fields(return_type)

    """
    ```gql
    #{operation_type} #{capitalized_operation_name}#{arguments_types} {
      #{operation_name}#{arguments} {#{return_fields}
      }
    }
    ```
    """
  end

  @spec capitalize_operation_name(String.t()) :: String.t()
  defp capitalize_operation_name(operation_name) do
    <<first_grapheme::utf8, rest::binary>> = operation_name
    String.capitalize(<<first_grapheme::utf8>>) <> rest
  end

  @spec argument_types_string([OperationDetailsHelpers.argument()]) :: String.t()
  defp argument_types_string([]), do: ""

  defp argument_types_string(args) do
    arg_types =
      Enum.map_join(args, ", ", fn arg ->
        arg_type = arg.type
        arg_name = arg.name

        type_suffix =
          if arg.required, do: "!", else: ""

        "$#{arg_name}: #{arg_type}#{type_suffix}"
      end)

    "(#{arg_types})"
  end

  @spec operation_arguments_string([OperationDetailsHelpers.argument()]) :: String.t()
  defp operation_arguments_string([]), do: ""

  defp operation_arguments_string(args) do
    arguments_string =
      Enum.map_join(args, ", ", fn arg ->
        "#{arg.name}: $#{arg.name}"
      end)

    "(#{arguments_string})"
  end

  @spec returned_fields(OperationDetailsHelpers.return_type()) :: String.t()
  defp returned_fields(%{kind: "SCALAR"}), do: ""

  defp returned_fields(%{kind: "OBJECT"} = return_type) do
    fields = Map.get(return_type, :fields, [])

    return_values =
      for field <- fields do
        if field.type == "OBJECT" do
          "#{field.name} {\n    }"
        else
          field.name
        end
      end

    case return_values do
      [_ | _] -> "\n    " <> Enum.join(return_values, "\n    ")
      _ -> ""
    end
  end

  defp returned_fields(%{kind: "UNION"} = return_type) do
    possible_types = Map.get(return_type, :possible_types, [])

    return_values =
      for possible_type <- possible_types do
        "... on #{possible_type.name} {\n    }"
      end

    case return_values do
      [_ | _] ->
        "\n    __typename\n    " <> Enum.join(return_values, "\n    ")

      _ ->
        ""
    end
  end

  defp returned_fields(%{kind: "INTERFACE"} = return_type) do
    fields = Map.get(return_type, :fields, [])
    possible_types = Map.get(return_type, :possible_types, [])

    interface_fields =
      for field <- fields do
        if field.type == "OBJECT" do
          "#{field.name} {\n    }"
        else
          field.name
        end
      end

    shared_fields_string =
      case interface_fields do
        [_ | _] -> "\n    " <> Enum.join(interface_fields, "\n    ")
        _ -> ""
      end

    specific_types =
      for possible_type <- possible_types do
        "... on #{possible_type.name} {\n    }"
      end

    specific_types_string =
      case specific_types do
        [_ | _] ->
          "\n    " <> Enum.join(specific_types, "\n    ")

        _ ->
          ""
      end

    shared_fields_string <> specific_types_string
  end
end
