defmodule GraphqlMarkdown.SinglePage do
  @moduledoc """
  Single page generator from Graphql to Markdown
  """
  alias GraphqlMarkdown.MarkdownHelpers
  alias GraphqlMarkdown.Renderer
  alias GraphqlMarkdown.Schema

  @spec render_schema(GraphqlMarkdown.Schema.t(), keyword) :: :ok | {:error, :renderer_error}
  def render_schema(schema_details, options) do
    dir = Keyword.get(options, :output_dir, ".")
    filename = Path.join(dir, "graphql_schema.md")

    case Renderer.start_link(name: "single", filename: filename) do
      {:ok, _pid} ->
        generate_title(options)
        render_newline()

        unless options[:no_toc] do
          generate_toc(schema_details, options)
          render_newline()
        end

        generate_sections(schema_details)
        Renderer.save(:single)
        [filename]

      _ ->
        {:error, :renderer_error}
    end
  end

  defp generate_title(options) do
    title = Keyword.get(options, :title, "Graphql Schema")
    render(MarkdownHelpers.header(title, 1, true))
  end

  defp generate_toc(_schema_details, toc: false), do: :ok

  defp generate_toc(schema_details, _options) do
    print_toc_type("queries", schema_details.queries)
    print_toc_type("mutations", schema_details.mutations)
    print_toc_type("objects", schema_details.objects)
    print_toc_type("inputs", schema_details.inputs)
    print_toc_type("enums", schema_details.enums)
    print_toc_type("scalars", schema_details.scalars)
    print_toc_type("interfaces", schema_details.interfaces)
    print_toc_type("unions", schema_details.unions)
  end

  defp print_toc_type(_, nil), do: ""

  defp print_toc_type(type_label, %{"fields" => fields} = _types)
       when type_label in ["queries", "mutations"] do
    # render(
    #   type_label
    #   |> String.capitalize()
    #   |> MarkdownHelpers.anchor()
    #   |> MarkdownHelpers.list(1)
    # )

    # Enum.each(fields, fn field ->
    #   render(
    #     field["name"]
    #     |> String.capitalize()
    #     |> MarkdownHelpers.anchor()
    #     |> MarkdownHelpers.list(2)
    #   )
    # end)

    print_toc_type(type_label, fields)
  end

  defp print_toc_type(type_label, types) do
    render(
      type_label
      |> String.capitalize()
      |> MarkdownHelpers.anchor()
      |> MarkdownHelpers.list(1)
    )

    Enum.each(types, fn type ->
      render(
        type["name"]
        |> String.capitalize()
        |> MarkdownHelpers.anchor()
        |> MarkdownHelpers.list(2)
      )
    end)
  end

  def generate_sections(schema_details) do
    Enum.each(
      ["queries", "mutations", "objects", "inputs", "enums", "scalars", "interfaces", "unions"],
      fn section_name ->
        generate_section(
          section_name,
          Map.get(schema_details, String.to_existing_atom(section_name))
        )

        render_newline()
      end
    )
  end

  def generate_section(type, []) do
    render(MarkdownHelpers.header(type, 2, true))
    render_newline()
    render("None")
  end

  def generate_section(type, nil) do
    render(MarkdownHelpers.header(type, 2, true))
    render_newline()
    render("None")
  end

  # Handles Mutations and Queries
  def generate_section(type, %{"fields" => fields} = _details)
      when type in ["queries", "mutations"] do
    render(MarkdownHelpers.header(type, 2, true))
    render_newline()

    Enum.each(fields, fn field ->
      render(MarkdownHelpers.header(field["name"], 3))
      render_newline()

      type_details =
        field["type"]
        |> Schema.field_type()
        |> MarkdownHelpers.anchor()

      render("Type: #{type_details}")
      render_newline()

      generate_description(field["description"])
      render_newline()

      data = generate_data(field["args"])
      render(MarkdownHelpers.table([field: {}, description: {}], data))
      render_newline()
    end)
  end

  def generate_section(type, details) do
    render(MarkdownHelpers.header(type, 2, true))
    render_newline()

    input_kind = Schema.input_kind()
    scalar_kind = Schema.scalar_kind()
    enum_kind = Schema.enum_kind()
    union_kind = Schema.union_kind()

    Enum.each(details, fn detail ->
      render(MarkdownHelpers.header(detail["name"], 3))
      render_newline()

      case detail["kind"] do
        ^input_kind ->
          data = generate_data(detail["inputFields"])
          render(MarkdownHelpers.table([field: {}, description: {}], data))

        ^scalar_kind ->
          generate_description(detail["description"])

        ^enum_kind ->
          generate_description(detail["description"])

          render_newline()

          data =
            Enum.map(detail["enumValues"], fn enum ->
              [enum["name"], enum["description"]]
            end)

          render(MarkdownHelpers.table([value: {}, description: {}], data))

        ^union_kind ->
          generate_description(detail["description"])

          render_newline()
          render("Possible types:")
          render_newline()

          generate_unions_possible_types(detail["possibleTypes"])

        _ ->
          data = generate_data(detail["fields"])
          render(MarkdownHelpers.table([field: {}, description: {}], data))
      end

      render_newline()
    end)
  end

  defp generate_unions_possible_types(types) do
    Enum.each(types, fn possible_type ->
      render(
        possible_type["name"]
        |> MarkdownHelpers.link("objects.html##{String.downcase(possible_type["name"])}")
        |> MarkdownHelpers.list(1)
      )
    end)
  end

  defp generate_description(description) do
    if description do
      render(description)
    end
  end

  defp generate_data(fields) do
    Enum.map(fields, fn field ->
      type_details =
        field["type"]
        |> Schema.full_field_type()
        |> MarkdownHelpers.anchor(Schema.field_type(field["type"]))

      default_value = MarkdownHelpers.default_value(field["defaultValue"])

      description =
        case default_value do
          "" ->
            field["description"]

          _ ->
            Enum.join([field["description"], default_value], ".")
        end

      [
        MarkdownHelpers.code(field["name"]) <> " ( " <> type_details <> " )",
        description
      ]
    end)
  end

  defp render(text) do
    Renderer.render(text, :single)
  end

  defp render_newline do
    Renderer.render_newline(:single)
  end
end
