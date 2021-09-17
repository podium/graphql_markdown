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
end
