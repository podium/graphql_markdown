defmodule GraphqlMarkdown.MultiPage do
  @moduledoc """
  Multi page generator from Graphql to Markdown
  """
  alias GraphqlMarkdown.MarkdownHelpers
  alias GraphqlMarkdown.Renderer
  alias GraphqlMarkdown.Schema

  def render_schema(schema_details, options) do
    output_dir = Keyword.get(options, :output_dir, ".")

    Enum.map(
      ["queries", "mutations", "objects", "inputs", "enums", "scalars", "interfaces", "unions"],
      fn section ->
        filename = Path.join(output_dir, "#{section}.md")

        case Renderer.start_link(name: section, filename: filename) do
          {:ok, _pid} ->
            generate_title(section, options)
            generate_section(section, Map.get(schema_details, String.to_atom(section)))
            Renderer.save(String.to_atom(section))
            filename

          _ ->
            {:error, :renderer_error}
        end
      end
    )
  end

  defp generate_title(type, _options) do
    render(type, MarkdownHelpers.header(type, 1, true))
    render_newline(type)
  end

  def generate_section(type, []) do
    render(type, "None")
  end

  def generate_section(type, nil) do
    render(type, "None")
  end

  def generate_section(type, %{"fields" => fields} = _details)
      when type in ["queries", "mutations"] do
    Enum.each(fields, fn field ->
      render(type, MarkdownHelpers.header(field["name"], 2))
      render_newline(type)

      type_details =
        field["type"]
        |> Schema.field_type()
        |> MarkdownHelpers.link(String.downcase(reference_for_kind(field)))

      render(type, "Type: #{type_details}")
      render_newline(type)

      generate_description(type, field["description"])
      render_newline(type)

      data = generate_data(field["args"])
      render(type, MarkdownHelpers.table([field: {}, description: {}], data))
      render_newline(type)
    end)
  end

  def generate_section(type, details) do
    input_kind = Schema.input_kind()
    scalar_kind = Schema.scalar_kind()
    enum_kind = Schema.enum_kind()
    union_kind = Schema.union_kind()

    Enum.each(details, fn detail ->
      render(type, MarkdownHelpers.header(detail["name"], 2))
      render_newline(type)

      case detail["kind"] do
        ^input_kind ->
          data = generate_data(detail["inputFields"])

          render(type, MarkdownHelpers.table([field: {}, description: {}], data))

        ^scalar_kind ->
          generate_description(type, detail["description"])

        ^enum_kind ->
          generate_description(type, detail["description"])

          render_newline(type)

          data =
            Enum.map(detail["enumValues"], fn enum ->
              [enum["name"], enum["description"]]
            end)

          render(type, MarkdownHelpers.table([value: {}, description: {}], data))

        ^union_kind ->
          generate_description(type, detail["description"])

          render_newline(type)
          render(type, "Possible types:")
          render_newline(type)
          generate_unions_possible_types(type, detail["possibleTypes"])

        _ ->
          data = generate_data(detail["fields"])
          render(type, MarkdownHelpers.table([field: {}, description: {}], data))
      end

      render_newline(type)
    end)
  end

  defp generate_unions_possible_types(section, types) do
    Enum.each(types, fn possible_type ->
      render(
        section,
        possible_type["name"]
        |> MarkdownHelpers.link("objects.html##{String.downcase(possible_type["name"])}")
        |> MarkdownHelpers.list(1)
      )
    end)
  end

  defp generate_description(section, description) do
    if description do
      render(section, description)
    end
  end

  defp generate_data(fields) do
    Enum.map(fields, fn field ->
      type_details =
        field["type"]
        |> Schema.full_field_type()
        |> MarkdownHelpers.link(reference_for_kind(field))

      default_value = MarkdownHelpers.default_value(field["defaultValue"])

      description =
        case default_value do
          "" ->
            "#{field["description"]}"

          _ ->
            Enum.join([field["description"], default_value], ".")
        end

      [
        MarkdownHelpers.code(field["name"]) <> " ( " <> type_details <> " )",
        description
      ]
    end)
  end

  defp reference_for_kind(field) do
    case Schema.field_kind(field["type"]) do
      "OBJECT" ->
        "objects.html#" <> Schema.field_type(field["type"])

      "INPUT_OBJECT" ->
        "inputs.html#" <> Schema.field_type(field["type"])

      "ENUM" ->
        "enums.html#" <> Schema.field_type(field["type"])

      _ ->
        "scalars.html#" <> Schema.field_type(field["type"])
    end
  end

  defp render(type, text) do
    Renderer.render(text, String.to_atom(type))
  end

  defp render_newline(type) do
    Renderer.render_newline(String.to_atom(type))
  end
end
