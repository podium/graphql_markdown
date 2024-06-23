defmodule GraphqlMarkdown.MarkdownHelpers do
  @moduledoc """
  A set of helpers to generate proper markdown easily
  """
  def header(text, level, capitalize \\ false)

  def header(text, level, true) do
    header(String.capitalize(text), level, false)
  end

  def header(text, level, _capitalize) do
    "#{String.duplicate("#", level)} #{text}"
  end

  def list(text, level, capitalize \\ false)

  def list(text, level, true) do
    list(String.capitalize(text), level, false)
  end

  def list(text, level, _capitalize) do
    "#{String.duplicate(" ", level * 2)}* #{text}"
  end

  def anchor(text, anchor_text \\ nil) do
    case anchor_text do
      nil ->
        link(text)

      _ ->
        link(text, "##{String.downcase(anchor_text)}")
    end
  end

  def link(text, url \\ nil) do
    case url do
      nil ->
        "[#{text}](##{String.downcase(text)})"

      _ ->
        "[#{text}](#{url})"
    end
  end

  def default_value(nil), do: ""

  def default_value(defaultValue) do
    "The default value is `#{defaultValue}`"
  end

  def code(text), do: "`#{text}`"

  def new_line do
    "\n"
  end

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

  defp capitalize_operation_name(operation_name) do
    <<first_grapheme::utf8, rest::binary>> = operation_name
    String.capitalize(<<first_grapheme::utf8>>) <> rest
  end

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

  defp operation_arguments_string([]), do: ""

  defp operation_arguments_string(args) do
    arguments_string =
      Enum.map_join(args, ", ", fn arg ->
        "#{arg.name}: $#{arg.name}"
      end)

    "(#{arguments_string})"
  end

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
end
