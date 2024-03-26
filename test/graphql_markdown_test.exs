defmodule GraphqlMarkdownTest do
  use ExUnit.Case, async: true
  doctest GraphqlMarkdown

  setup do
    File.mkdir_p!("guides")
  end

  describe "#generate" do
    test "convert schema to markdown as single page" do
      assert GraphqlMarkdown.generate(schema: "test/fixtures/schema.json", output_dir: "guides") ==
               {:ok, ["guides/graphql_schema.md"]}

      # assert that it can generate multiple times
      assert GraphqlMarkdown.generate(schema: "test/fixtures/schema.json", output_dir: "guides") ==
               {:ok, ["guides/graphql_schema.md"]}
    end

    test "convert schema to markdown as single page with no TOC" do
      assert GraphqlMarkdown.generate(
               schema: "test/fixtures/schema.json",
               output_dir: "guides",
               no_toc: true
             ) ==
               {:ok, ["guides/graphql_schema.md"]}

      content = File.read!("guides/graphql_schema.md")
      refute content =~ "* [Queries](#queries) "
    end

    test "convert schema to markdown as single page with custom title" do
      assert GraphqlMarkdown.generate(
               schema: "test/fixtures/schema.json",
               output_dir: "guides",
               title: "Other Title"
             ) ==
               {:ok, ["guides/graphql_schema.md"]}

      content = File.read!("guides/graphql_schema.md")
      assert content =~ "# Other title"
    end

    test "convert schema to markdown as multipage" do
      assert GraphqlMarkdown.generate(
               schema: "test/fixtures/schema.json",
               output_dir: "guides",
               multi_page: true
             ) ==
               {:ok,
                [
                  "guides/queries.md",
                  "guides/mutations.md",
                  "guides/objects.md",
                  "guides/inputs.md",
                  "guides/enums.md",
                  "guides/scalars.md",
                  "guides/interfaces.md",
                  "guides/unions.md"
                ]}

      # assert that it can generate multiple times
      assert GraphqlMarkdown.generate(
               schema: "test/fixtures/schema.json",
               output_dir: "guides",
               multi_page: true
             ) ==
               {:ok,
                [
                  "guides/queries.md",
                  "guides/mutations.md",
                  "guides/objects.md",
                  "guides/inputs.md",
                  "guides/enums.md",
                  "guides/scalars.md",
                  "guides/interfaces.md",
                  "guides/unions.md"
                ]}
    end

    test "fails to load the file" do
      assert GraphqlMarkdown.generate(schema: "dontexistfile") == {:error, :enoent}
    end

    test "fails to find a schema" do
      assert GraphqlMarkdown.generate(schema: "test/fixtures/invalid_schema.json") ==
               {:error, :invalid_schema}
    end

    test "fails to decode the Json" do
      assert {
               :error,
               %Jason.DecodeError{}
             } = GraphqlMarkdown.generate(schema: "test/fixtures/invalid_json_schema.json")
    end
  end
end
